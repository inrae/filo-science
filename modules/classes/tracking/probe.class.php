<?php

/**
 * ORM of table probe
 */
class Probe extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct(PDO $bdd, $param = array())
    {
        $this->table = "probe";
        $date = new DateTime();
        $date->add(new DateInterval('P1Y'));
        $this->colonnes = array(
            "probe_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "station_id" => array("type" => 0, "requis" => 1, "parentAttrib" => 1),
            "probe_code" => array("type" => 0, "requis" => 1),
            "date_from" => array("type" => 2, "defaultValue" => $this->formatDateDBversLocal(date('Y-m-d'))),
            "date_to" => array("type" => 2, "defaultValue" => $this->formatDateDBversLocal($date->format("Y-m-d")))
        );
        parent::__construct($bdd, $param);
    }
}
