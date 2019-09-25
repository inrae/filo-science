<?php
class Antenna extends ObjetBDD
{
    private $sridAntenna = 4326;

    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct(PDO $bdd, array $param = array())
    {
        $this->table = "antenna";
        $this->colonnes = array(
            "antenna_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "station_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "antenna_code" => array("type" => 0, "requis" => 1),
            "diameter" => array("type" => 1),
            "geom_polygon" => array("type" => 4)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * overwrite of ecrire to generate the polygon of type circle 
     *
     * @param array $data
     * @return int
     */
    function ecrire($data)
    {
        if ($data["diameter"] == 0) {
            $data["geom_polygon"] = "";
        }
        $id = parent::ecrire($data);
        if ($data["diameter"] > 0 && is_numeric($data["diameter"])) {
            /**
             * Generate a polygon from the center of the station and the diameter
             * 
             * Get the coordinates of the station
             */
            require_once "modules/classes/station.class.php";
            $station = new Station($this->connection, $this->paramori);
            $dstation = $station->getDetail($data["station_id"]);
            if (strlen($dstation["station_long"]) > 0 && strlen($dstation["station_lat"]) > 0) {
                $sql = "update antenna set geom_polygon = 
                        st_transform( 
                            st_buffer ( 
                                st_transform ( 
                                    st_geomfromtext('POINT(" . $dstation["station_long"] . " " . $dstation["station_lat"] . ")', " . $this->sridAntenna . ")
                                , " . $dstation["metric_srid"] . ")
                            , " . $data["diameter"] . ")
                        ," . $this->sridAntenna . ")
                        where antenna_id = $id";
                $this->execute($sql);
            }
        }
        return $id;
    }
}
