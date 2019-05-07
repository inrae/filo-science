<?php
class Station extends ObjetBDD
{
private $sql = "select station_id, station_name, station_long, station_lat, station_pk, station_code
            ,project_id, project_name
            ,river_id, river_name
            from station 
            left outer join project using (project_id)
            left outer join river using (river_id)
            ";
    /**
     * Constructor
     * 
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "station";
        $this->colonnes = array(
            "station_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "station_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "project_id" => array(
                "type" => 1
            ),
            "station_code" => array(
                "type" => 0
            ),
            "station_long" => array(
                "type" => 1
            ),
            "station_lat" => array(
                "type" => 1
            ),
            "station_pk" => array("type" => 1),
            "river_id" => array("type" => 1)
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Test if a station exists
     *
     * @param string $name
     * @return boolean
     */
    function isExists($name)
    {
        $id = 0;
        if (strlen($name) > 0) {
            $sql = "select station_id from station where station_name = :name";
            $id = $this->lireParamAsPrepared($sql, array(
                "name" => $name
            ));
        }
        if ($id > 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Get station_id from name
     * 
     * @param string $name
     * @return int
     */
    function getIdFromName($name)
    {
        $id = 0;
        if (strlen($name) > 0) {
            $sql = "select station_id from station where station_name = :name";
            $data = $this->lireParamAsPrepared($sql, array(
                "name" => $name
            ));
            if ($data["station_id"] > 0) {
                $id = $data["station_id"];
            }
        }
        return $id;
    }

    /**
     * Get the list of stations attached at a project
     *
     * @param int $project_id
     * @param boolean $with_noaffected
     *            : if true, all non-affected places are associated
     *            at the project places
     * @return array
     */
    function getListFromProject($project_id = 0, $with_noaffected = true)
    {

        $where = "";
        $order = " order by station_code, station_name";
        if ($with_noaffected) {
            $where = " where project_id is null";
        }
        if ($with_noaffected && $project_id > 0) {
            $where .= " or ";
        }
        if ($project_id > 0) {
            if ($where == "") {
                $where = " where ";
            }
            $where .= " project_id = :project_id";
            return $this->getListeParamAsPrepared($this->sql . $where . $order, array(
                "project_id" => $project_id
            ));
        } else {
            return $this->getListeParam($this->sql . $where . $order);
        }
    }

    /**
     * Get geographic coords from station
     * @param int $station_id
     * @return array
     */
    function getCoordinates($station_id)
    {
        if ($station_id > 0) {
            $sql = "select station_long, station_lat from station
                    where station_id = :station_id";
            return $this->lireParamAsPrepared($sql, array("station_id" => $station_id));
        }
    }
}
