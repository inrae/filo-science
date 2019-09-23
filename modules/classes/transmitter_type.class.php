<?php

/**
 * transmitter_type ORM class
 */
class TransmitterType extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "transmitter_type";
        $this->colonnes = array(
            "transmitter_type_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "transmitter_type_name" => array("type" => 0, "requis" => 1),
            "characteristics" => array("type" => 0),
            "technology" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
}
