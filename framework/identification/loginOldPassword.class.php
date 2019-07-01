<?php
/**
 * Classe de gestion de l'enregistrement des anciens mots de passe
 *
 * @author quinton
 *
 */
class LoginOldPassword extends ObjetBDD
{

    /**
     * Constructeur
     *
     * @param pdo   $bdd
     * @param array $ObjetBDDParam
     */
    public function __construct($bdd, $param)
    {
        $this->table = "login_oldpassword";
        $this->colonnes = array(
            "login_oldpassword_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0,
            ),
            "id" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1,
            ),
            "password" => array(
                "type" => 0,
            ),
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Fonction retournant le nombre de mots de passe deja utilises pour le hash fourni
     *
     * @param string $login
     * @param string $password_hash
     *
     * @return number
     */
    public function testPassword($login, $password_hash)
    {
        $login = $this->encodeData($login);
        $sql = 'select count(o.login_oldpassword_id) as "nb"
				from ' . $this->table . " o
				join logingestion on logingestion.id = o.id
				where login = '" . $login . "'
					and o.password = '" . $password_hash . "'";
        $res = $this->lireParam($sql);
        return $res["nb"];
    }

    /**
     * Enregistre un mot de passe dans la base des anciens mots de passe utilises
     *
     * @param int $id
     * @param string $password_hash
     *
     * @return int
     */
    public function setPassword($id, $password_hash)
    {
        if ($id > 0) {
            $data = array(
                "id" => $id,
                "password" => $password_hash,
            );
            return $this->ecrire($data);
        }
    }
}