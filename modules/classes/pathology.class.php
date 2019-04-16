<?php
/**
 * ORM for the table pathology
 */
class Pathology extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "pathology";
        $this->colonnes = array(
            "pathology_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "pathology_name" => array("requis" => 1),
            "pathology_code" => array("type" => 0),
            "pathology_description" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
}
