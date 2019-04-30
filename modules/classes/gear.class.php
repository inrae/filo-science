<?php
/**
 * ORM for the table gear
 */
class Gear extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "gear";
        $this->colonnes = array(
            "gear_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "gear_name" => array("requis" => 1),
            "gear_length" => array("type" => 1),
            "gear_height" => array("type" => 1),
            "mesh_size" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
}
