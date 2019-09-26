<?php

/**
 * individual_tracking ORM class
 */
class IndividualTracking extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "individual_tracking";
        $this->colonnes = array(
            "individual_id" => array("type" => 1, "requis" => 1, "key" => 1),
            "release_station_id" => array("type" => 1),
            "transmitter_type_id" => array("type" => 1),
            "project_id" => array("type" => 1, "requis" => 1),
            "taxon_id" => array("type"=>1, "requis"=>1)
        );
        $this->id_auto = 0;
        parent::__construct($bdd, $param);
    }
}
