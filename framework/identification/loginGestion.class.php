<?php

/**
 * Classe permettant de manipuler les logins stockés en base de données locale
 */
class LoginGestion extends ObjetBDD
{

    public function __construct($link, $param = array())
    {
        $this->table = "logingestion";
        $this->id_auto = 1;
        $this->colonnes = array(
            "id" => array(
                "type" => 1,
                "key" => 1,
            ),
            "datemodif" => array(
                "type" => 2,
                "defaultValue" => "getDateJour",
            ),
            "mail" => array(
                "pattern" => "#^.+@.+\.[a-zA-Z]{2,6}$#",
            ),
            "login" => array(
                'requis' => 1,
            ),
            "nom" => array(
                "type" => 0,
            ),
            "prenom" => array(
                "type" => 0,
            ),
            "actif" => array(
                'type' => 1,
                'defaultValue' => 1,
            ),
            "password" => array(
                'type' => 0,
                'longueur' => 256,
            ),
            "is_clientws" => array(
                "type" => 1,
                "defaultValue" => '0',
            ),
            "tokenws" => array(
                'type' => 0,
            ),
        );
        parent::__construct($link, $param);
    }

    /**
     * Vérification du login en mode base de données
     *
     * @param string $login
     * @param string $password
     * @return boolean
     */
    public function controlLogin($login, $password)
    {
        global $log;
        $retour = false;
        if (strlen($login) > 0 && strlen($password) > 0) {
            $login = $this->encodeData($login);
            $password = hash("sha256", $password . $login);
            $sql = "select login from LoginGestion where login ='" . $login . "' and password = '" . $password . "' and actif = 1";
            $res = ObjetBDD::lireParam($sql);
            if ($res["login"] == $login) {
                $log->setLog($login, "connexion", "db-ok");
                $retour = true;
            } else {
                $log->setLog($login, "connexion", "db-ko");
            }
        }
        return $retour;
    }

    /**
     * Recupere le login a partir d'un jeton pour les services web
     *
     * @param String $token
     * @return array
     */
    public function getLoginFromTokenWS($login, $token)
    {
        if (strlen($token) > 0 && strlen($login) > 0) {
            $sql = "select login from logingestion where is_clientws = '1' and actif = '1'
            and login = :login
            and tokenws = :tokenws";
            return $this->lireParamAsPrepared($sql, array(
                "login" => $login,
                "tokenws" => $token,
            ));
        }
    }

    /**
     * Retourne la liste des logins existants, triee par nom-prenom
     *
     * @return array
     */
    public function getListeTriee()
    {
        $sql = 'select id,login,nom,prenom,mail,actif from LoginGestion order by nom,prenom, login';
        return ObjetBDD::getListeParam($sql);
    }

    /**
     * Preparation de la mise en table, avec verification du motde passe
     * (non-PHPdoc)
     *
     * @see ObjetBDD::ecrire()
     */
    public function ecrire($data)
    {
        if (strlen($data["pass1"]) > 0 && strlen($data["pass2"]) > 0 && $data["pass1"] == $data["pass2"]) {
            if ($this->controleComplexite($data["pass1"]) > 2 && strlen($data["pass1"]) > 9) {
                $data["password"] = hash("sha256", $data["pass1"] . $data["login"]);
            } else {
                throw new IdentificationException("Password not enough complex or too small");
            }
        }
        $data["datemodif"] = date($_SESSION["MASKDATELONG"]);
        /*
         * Traitement de la generation du token d'identification ws
         */
        if ($data["is_clientws"] == 1 && strlen($data["tokenws"]) == 0) {
            $data["tokenws"] = bin2hex(openssl_random_pseudo_bytes(32));
        } else {
            $data["is_clientws"] = 0;
        }
        $id = parent::ecrire($data);
        if ($id > 0 && strlen($data["password"]) > 0) {
            include_once 'framework/identification/loginOldPassword.class.php';
            $lgo = new LoginOldPassword($this->connection, $this->paramori);
            $lgo->setPassword($id, $data["password"]);
        }
        return $id;
    }

    /**
     * Surcharge de la fonction supprimer pour effacer les traces des anciens mots de passe
     *
     * {@inheritdoc}
     *
     * @see ObjetBDD::supprimer()
     */
    public function supprimer($id)
    {
        /*
         * Suppression le cas echeant des anciens logins enregistres
         */
        include_once 'framework/identification/loginOldPassword.class.php';
        $loginOP = new LoginOldPassword($this->connection, $this->paramori);
        $loginOP->supprimerChamp($id, "id");
        $data = $this->lire($id);
        if (parent::supprimer($id) > 0) {
            /*
             * Recherche si un enregistrement existe dans la gestion des droits
             */
            require_once 'framework/droits/droits.class.php';
            $acllogin = new Acllogin($this->connection, $this->paramori);
            $datalogin = $acllogin->getFromLogin($data["login"]);
            if ($datalogin["acllogin_id"] > 0) {
                $acllogin->supprimer($datalogin["acllogin_id"]);
            }
        }
    }

    public function getFromLogin($login)
    {
        if (strlen($login) > 0) {
            $sql = "select * from " . $this->table . " where login = :login";
            return $this->lireParamAsPrepared($sql, array("login" => $login));
        }
    }

    /**
     * Fonction de validation de changement du mot de passe
     *
     * @param string $oldpassword
     * @param string $pass1
     * @param string $pass2
     * @return number
     */
    public function changePassword($oldpassword, $pass1, $pass2)
    {
        global $log, $message;
        $retour = 0;
        if (isset($_SESSION["login"])) {
            $oldData = $this->lireByLogin($_SESSION["login"]);
            if ($log->getLastConnexionType($_SESSION["login"]) == "db") {
                $oldpassword_hash = $this->passwordHash($_SESSION["login"], $oldpassword);
                if ($oldpassword_hash == $oldData["password"]) {
                    /*
                     * Verifications de validite du mot de passe
                     */
                    if ($this->passwordVerify($_SESSION["login"], $pass1, $pass2)) {
                        $retour = $this->writeNewPassword($_SESSION["login"], $pass1);
                    } else {
                        $message->set(_("La modification du mot de passe a échoué"), true);
                    }
                } else {
                    $message->set(_("L'ancien mot de passe est incorrect"), true);
                }
            } else {
                $message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"), true);
            }
        }

        return $retour;
    }

    /**
     * Calcule le hash d'un mot de passe
     *
     * @param string $login
     * @param string $password
     * @throws Exception
     * @return string
     */
    public function passwordHash($login, $password)
    {
        if (strlen($login) == 0 || strlen($password) == 0) {
            throw new IdentificationException("password hashing not possible");
        } else {
            return hash("sha256", $password . $login);
        }
    }

    /**
     * Declenche le changement de mot de passe apres perte
     *
     * @param string $login
     * @param string $pass1
     * @param string $pass2
     * @return number
     */
    public function changePasswordAfterLost($login, $pass1, $pass2)
    {
        $retour = 0;
        if (strlen($login) > 0) {
            if ($this->passwordVerify($login, $pass1, $pass2)) {
                $retour = $this->writeNewPassword($login, $pass1);
            }
        }
        return $retour;
    }

    /**
     * Ecrit le nouveau mot de passe en base de donnees
     *
     * @param string $login
     * @param string $pass
     * @return number
     */
    private function writeNewPassword($login, $pass)
    {
        global $log, $message;
        $retour = 0;
        $oldData = $this->lireByLogin($login);
        if ($log->getLastConnexionType($login) == "db") {
            $data = $oldData;
            $data["password"] = $this->passwordHash($login, $pass);
            $data["datemodif"] = date('d-m-y');
            if ($this->ecrire($data) > 0) {
                $retour = 1;
                $log->setLog($login, "password_change", "ip:" . $_SESSION["remoteIP"]);
                /*
                 * Ecriture du mot de passe dans la table des mots de passe deja utilises
                 */
                include_once 'framework/identification/loginOldPassword.class.php';
                $loginOldPassword = new LoginOldPassword($this->connection, $this->paramori);
                $loginOldPassword->setPassword($data["id"], $data["password"]);

                $message->set(_("Le mot de passe a été modifié"));
            } else {
                $message->set(_("Echec de modification du mot de passe pour une raison inconnue. Si le problème persiste, contactez l'assistance"), true);
            }
        } else {
            $message->set(_("Le mode d'identification utilisé pour votre compte n'autorise pas la modification du mot de passe depuis cette application"), true);
        }
        return $retour;
    }

    /**
     * Fonction verifiant la validite du mot de passe fourni,
     * avant changement
     *
     * @param string $login
     * @param string $pass1
     * @param string $pass2
     * @return boolean
     */
    private function passwordVerify($login, $pass1, $pass2)
    {
        global $message, $APPLI_passwordMinLength;
        $ok = false;
        /*
         * Verification que le mot de passe soit identique
         */
        if ($pass1 == $pass2) {
            /*
             * Verification de la longueur - minimum : 10 caracteres
             */
            if (strlen($pass1) >= $APPLI_passwordMinLength) {
                /*
                 * Verification de la complexite du mot de passe
                 */
                if ($this->controleComplexite($pass1) >= 3) {
                    /**
                     * Verify strength of password
                     */
                    $zxcvbn = new Zxcvbn();
                    $strength = $zxcvbn->passwordStrength($pass1, array());
                    if ($strength["score"] > 1) {
                        /*
                     * calcul du sha256 du mot de passe
                     */
                        $password_hash = $this->passwordHash($login, $pass1);
                        /*
                     * Verification que le mot de passe n'a pas deja ete employe
                     */
                        include_once 'framework/identification/loginOldPassword.class.php';
                        $loginOldPassword = new LoginOldPassword($this->connection, $this->paramori);
                        $nb = $loginOldPassword->testPassword($login, $password_hash);
                        if ($nb == 0) {
                            $ok = true;
                        } else {
                            $message->set(_("Le mot de passe a déjà été utilisé"), true);
                        }
                    } else {
                        $message->set(_("Le mot de passe n'est pas assez fort"), true);
                    }
                } else {
                    $message->set(_("Le mot de passe n'est pas assez complexe"), true);
                }
            } else {
                $message->set(_("Le mot de passe est trop court"), true);
            }
        } else {
            $message->set(_("Le mot de passe n'est pas identique dans les deux zones"), true);
        }
        return $ok;
    }

    /**
     * Fonction verifiant la complexite d'un mot de passe
     * Retourne le nombre de jeux de caracteres differents utilises
     *
     * @param string $password
     * @return number
     */
    public function controleComplexite($password)
    {
        $long = strlen($password);
        $type = array(
            "min" => 0,
            "maj" => 0,
            "chiffre" => 0,
            "other" => 0,
        );
        for ($i = 0; $i < $long; $i++) {
            $car = substr($password, $i, 1);
            if ($type["min"] == 0) {
                $type["min"] = preg_match("/[a-z]/", $car);
            }
            if ($type["maj"] == 0) {
                $type["maj"] = preg_match("/[A-Z]/", $car);
            }
            if ($type["chiffre"] == 0) {
                $type["chiffre"] = preg_match("/[0-9]/", $car);
            }
            if ($type["other"] == 0) {
                $type["other"] = preg_match("/[^0-9a-zA-Z]/", $car);
            }
        }
        return $type["min"] + $type["maj"] + $type["chiffre"] + $type["other"];
    }

    /**
     * Retourne un enregistrement a partir du login
     *
     * @param string $login
     * @return array
     */
    public function lireByLogin($login)
    {
        $login = $this->encodeData($login);
        $sql = "select * from " . $this->table . "
				where login = '" . $login . "'";
        return $this->lireParam($sql);
    }

    /**
     * Retourne un enregistrement a partir du mail
     *
     * @param string $mail
     *
     * @return array
     */
    public function getFromMail($mail)
    {
        $mail = $this->encodeData($mail);
        if (strlen($mail) > 0) {
            $sql = "select id, nom, prenom, login, mail, actif ";
            $sql .= " from " . $this->table;
            $sql .= " where lower(mail) = lower(:mail)";
            $sql .= " order by id desc limit 1";
            return $this->lireParamAsPrepared(
                $sql,
                array(
                    "mail" => $mail,
                )
            );
        }
    }
}
