<?php
/**
 * ORM of table detection
 */
class Detection extends ObjetBDD {

    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct(PDO $bdd, array $param = array())
    {
        $this->table = "detection";
        $this->colonnes = array(
            "detection_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "individual_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "antenna_id" => array("type" => 1),
            "location_id"=>array("type"=>1),
            "detection_date"=>array("type"=>3),
            "nb_events"=>array("type"=>1),
            "duration"=>array("type"=>1),
            "validity"=>array("type"=>1),
            "signal_force"=>array("type"=>1),
            "observation"=>array("type"=>0)
        );
        parent::__construct($bdd, $param);
    }
}