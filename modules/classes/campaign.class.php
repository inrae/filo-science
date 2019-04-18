<?php

/**
 * ORM of table campaign
 */
class Campaign extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array()) {
        $this->table = "campaign";
        $this->colonnes = array(
            "campaign_id"=>array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "campaign_name"=>array("requis"=>1, "type"=>0),
            "project_id"=>array("requis"=>1, "parentAttrib"=>1)
        );
        parent::__construct($bdd, $param);
    }

}