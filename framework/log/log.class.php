<?php
/**
 * Classe permettant d'enregistrer toutes les operations effectuees dans la base
 *
 * @author quinton
 *
 */
class Log extends ObjetBDD
{

    /**
     * Constructeur
     *
     * @param pdo   $p_connection
     * @param array $param
     */
    public function __construct($bdd, $param = null)
    {
        $this->table = "log";
        $this->colonnes = array(
            "log_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0,
            ),
            "login" => array(
                "type" => 0,
                "requis" => 0,
            ),
            "nom_module" => array(
                "type" => 0,
            ),
            "log_date" => array(
                "type" => 3,
                "requis" => 1,
            ),
            "commentaire" => array(
                "type" => 0,
            ),
            "ipaddress" => array(
                "type" => 0,
            ),
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Fonction enregistrant un evenement dans la table
     *
     * @param string $module
     * @param string $comment
     *
     * @return integer
     */
    public function setLog($login, $module, $commentaire = null)
    {
        global $GACL_aco;
        $data = array(
            "log_id" => 0,
            "commentaire" => $commentaire,
        );
        if (is_null($login)) {
            if (!is_null($_SESSION["login"])) {
                $login = $_SESSION["login"];
            } else {
                $login = "unknown";
            }
        }
        $data["login"] = $login;
        if (is_null($module)) {
            $module = "unknown";
        }
        $data["nom_module"] = $GACL_aco . "-" . $module;
        $data["log_date"] = date($_SESSION["MASKDATELONG"]);
        $data["ipaddress"] = $this->getIPClientAddress();
        return $this->ecrire($data);
    }

    /**
     * Fonction de purge du fichier de traces
     *
     * @param int $nbJours : nombre de jours de conservation
     *
     * @return int
     */
    public function purge($nbJours)
    {
        if ($nbJours > 0) {
            $sql = "delete from " . $this->table . "
					where log_date < current_date - interval '" . $nbJours . " day'";
            return $this->executeSQL($sql);
        }
    }

    /**
     * Recupere l'adresse IP de l'agent
     *
     * @return IPAddress
     */
    public function getIPClientAddress()
    {
        /*
         * Recherche si le serveur est accessible derriere un reverse-proxy
         */
        if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])) {
            return $_SERVER["HTTP_X_FORWARDED_FOR"];
        } else if (isset($_SERVER["REMOTE_ADDR"])) {
            /*
             * Cas classique
             */
            return $_SERVER["REMOTE_ADDR"];
        } else {
            return -1;
        }
    }

    /**
     * Renvoie les informations de derniere connexion
     *
     * @return array
     */
    public function getLastConnexion()
    {
        if (isset($_SESSION["login"])) {
            $sql = "select log_date, ipaddress from log where login = :login
            and nom_module like '%connexion' and commentaire like '%ok'
            order by log_id desc limit 2";
            $data = $this->getListeParamAsPrepared(
                $sql,
                array(
                    "login" => $_SESSION["login"],
                )
            );
            return $data[1];
        }
    }
    /**
     * Get the list of all connexions during max duration of session
     *
     * @param integer $duration
     * @return void
     */
    public function getLastConnections($duration = 36000)
    {
        if (isset($_SESSION["login"])) {

            $sql = "select log_date, ipaddress from log where login = :login
            and nom_module like '%connexion' and commentaire like '%ok'
            and log_date > :datefrom
            order by log_id desc";
            $date = new DateTime(now);
            $date->sub(new DateInterval("PT" . $duration . "S"));
            $data = $this->getListeParamAsPrepared(
                $sql,
                array(
                    "login" => $_SESSION["login"],
                    "datefrom" => $date->format(DATELONGMASK),
                )
            );
            return $data;
        }
    }

    /**
     * Retourne le dernier type de connexion realisee pour un compte
     *
     * @param string $login
     *
     * @return string
     */
    public function getLastConnexionType($login)
    {
        if (strlen($login) > 0) {
            $sql = "select commentaire from log";
            $sql .= " where login = :login and nom_module like '%connexion' and commentaire like '%ok'";
            $sql .= "order by log_id desc limit 1";
            $data = $this->lireParamAsPrepared(
                $sql,
                array(
                    "login" => $login,
                )
            );
            $commentaire = explode("-", $data["commentaire"]);
            return $commentaire[0];
        }
    }

    /**
     * Recherche si le compte a fait l'objet de trop de tentatives de connexion
     * Si c'est le cas, declenche le blocage du compte pour la duree indiquee
     * La duree de blocage est reinitialisee a chaque tentative pendant la periode
     * de contention
     *
     * @param string $login
     * @param number $maxtime
     * @param number $nbMax
     *
     * @return boolean
     */
    public function isAccountBlocked($login, $maxtime = 600, $nbMax = 10)
    {

        $is_blocked = true;
        /*
         * Verification si le compte est bloque, et depuis quand
         */
        $accountBlocking = false;
        $date = new DateTime(now);
        $date->sub(new DateInterval("PT" . $maxtime . "S"));
        $sql = "select log_id from log where login = :login " . " and nom_module = 'connexionBlocking'" . " and log_date > :blockingdate " . " order by log_id desc limit 1";
        $data = $this->lireParamAsPrepared(
            $sql,
            array(
                "login" => $login,
                "blockingdate" => $date->format(DATELONGMASK),
            )
        );
        if ($data["log_id"] > 0) {
            $accountBlocking = true;
        }
        if (!$accountBlocking) {
            $sql = "select log_date, commentaire from log where login = :login
                    and nom_module like '%connexion'
                    and log_date > :blockingdate
                order by log_id desc limit :nbmax";
            $data = $this->getListeParamAsPrepared(
                $sql,
                array(
                    "login" => $login,
                    "nbmax" => $nbMax,
                    "blockingdate" => $date->format(DATELONGMASK),
                )
            );
            $nb = 0;
            /*
             * Recherche si une connexion a reussi
             */
            foreach ($data as $value) {
                if (substr($value["commentaire"], -2) == "ok") {
                    $is_blocked = false;
                    break;
                }
                $nb++;
            }
            if ($nb >= $nbMax) {
                /*
                 * Verrouillage du compte
                 */
                $this->blockingAccount($login);
            } else {
                $is_blocked = false;
            }
        }
        return $is_blocked;
    }

    /**
     * Fonction de blocage d'un compte
     * - cree un enregistrement dans la table log
     * - envoie un mail aux administrateurs
     *
     * @param string $login
     */
    public function blockingAccount($login)
    {
        $this->setLog($login, "connexionBlocking");
        global $message, $MAIL_enabled, $APPLI_mail, $APPLI_address, $APPLI_mailToAdminPeriod;
        $date = date("Y-m-d H:i:s");
        $message->setSyslog("connexionBlocking for login $login");
        if ($MAIL_enabled == 1) {
            include_once 'framework/identification/mail.class.php';
            include_once 'framework/droits/droits.class.php';
            $MAIL_param = array(
                "replyTo" => "$APPLI_mail",
                "subject" => "SECURITY REPORTING - " . $_SESSION["APPLI_code"] . " - account blocked",
                "from" => "$APPLI_mail",
                "contents" => "<html><body>" . "The account <b>$login<b> was blocked at $date for too many connection attempts" . '<br>Software : <a href="' . $APPLI_address . '">' . $APPLI_address . "</a>" . '</body></html>',
            );
            /*
             * Recherche de la liste des administrateurs
             */
            $aclAco = new Aclaco($this->connection, $this->paramori);
            $logins = $aclAco->getLogins("admin");
            /*
             * Envoi des mails aux administrateurs
             */
            $lastDate = new DateTime(now);
            if (isset($APPLI_mailToAdminPeriod)) {
                $period = $APPLI_mailToAdminPeriod;
            } else {
                $period = 7200;
            }
            $interval = new DateInterval('PT' . $period . 'S');
            $lastDate->sub($interval);
            $mail = new Mail($MAIL_param);
            $loginGestion = new LoginGestion($this->connection, $this->paramori);
            foreach ($logins as $value) {
                $admin = $value["login"];
                $dataLogin = $loginGestion->lireByLogin($admin);
                if (strlen($dataLogin["mail"]) > 0) {
                    /*
                     * Recherche si un mail a deja ete adresse a l'administrateur pour ce blocage
                     */
                    $sql = 'select log_id, log_date from log' . " where nom_module like '%sendMailAdminForBlocking'" . ' and login = :login' . ' and commentaire = :admin' . ' and log_date > :lastdate' . ' order by log_id desc limit 1';
                    $logval = $this->lireParamAsPrepared(
                        $sql,
                        array(
                            "admin" => $admin,
                            "login" => $login,
                            "lastdate" => $lastDate->format("Y-m-d H:i:s"),
                        )
                    );
                    if (!$logval["log_id"] > 0) {
                        if ($mail->sendMail($dataLogin["mail"], array())) {
                            $this->setLog($login, "sendMailAdminForBlocking", $value["login"]);
                        } else {
                            global $message;
                            $message->setSyslog("error_sendmail_to_admin:" . $dataLogin["mail"]);
                        }
                    }
                }
            }
        }
    }
}