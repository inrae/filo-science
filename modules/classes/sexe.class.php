<?php
/**
 * ORM for the table sexe
 */
class Sexe extends ObjetBDD {
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "sexe";
        $this->colonnes = array( "sexe_id"=> array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
        "sexe_name"=>array("requis"=>1),
        "sexe_code"=>array("requis"=>1));
        parent::__construct($bdd, $param);
        
    }
}