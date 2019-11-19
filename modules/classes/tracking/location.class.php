<?php
/**
 * ORM of the table location
 */
class Location extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct(PDO $bdd, array $param = array())
    {
        $this->table = "location";
        $this->srid = 4326;
        $this->colonnes = array(
            "location_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "individual_id"=>array("type"=>1, "requis"=>1, "parentAttrib" => 1),
            "antenna_type_id"=>array("type"=>1),
            "detection_date" => array("type"=>3, "requis"=>1, "defaultValue"=>"getDateHeure"),
            "location_pk" => array("type" => 1),
            "location_long" => array("type" => 1),
            "location_lat" => array("type" => 1),
            "signal_force" => array("type" => 1),
            "observation" => array("type" => 0),
            "geom" => array("type" => 4)
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Add the generation of the geom point to the location
     *
     * @param array $data
     * @return int
     */
    function ecrire(array $data)
    {
        if (strlen($data["location_long"]) > 0 && strlen($data["location_lat"]) > 0) {
            $data["geom"] = "POINT(" . $data["location_long"] . " " . $data["location_lat"] . ")";
        } else {
            $data["geom"] = "";
        }
        return parent::ecrire($data);
    }
}
