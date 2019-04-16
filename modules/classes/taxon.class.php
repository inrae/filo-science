<?php
/**
 * ORM for the table taxon
 */
class Taxon extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "taxon";
        $this->colonnes = array(
            "taxon_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "scientific_name" => array("requis" => 1),
            "author" => array("type" => 0),
            "common_name" => array("type" => 0),
            "taxon_code" => array("type" => 0),
            "fresh_code" => array("type" => 0),
            "sea_code" => array("type" => 0),
            "ecotype" => array("type" => 0),
            "length_max" => array("type" => 1),
            "weight_max" => array("type" => 1)
        );
        parent::__construct($bdd, $param);
    }
}
