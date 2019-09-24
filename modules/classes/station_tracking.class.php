<?php
class StationTracking extends ObjetBDD
{
    private $sql = "select station_id, station_name, project_id, project_name,
            station_long, station_lat, station_pk, river_id, river_name,station_code,
            station_type_id, station_type_name
            from station_tracking
            join station using (station_id)
            join station_type using (station_type_id)
            left outer join river using (river_id)
            left outer join project using (project_id)
            ";
    /**
     * Constructor
     * 
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, array $param = array())
    {
        $this->table = "station_tracking";
        $this->colonnes = array(
            "station_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "station_type_id" => array("type" => 1, "requis" => 1)
        );
        $this->id_auto = 0;
        parent::__construct($bdd, $param);
    }
    /**
     * Surcharge pour rajouter les infos de la table station
     *
     * @param int $id
     * @return array
     */
    function lire($id)
    {
        if ($id == 0) {
            $data = $this->getDefaultValue();
        } else {
            $where = " where station_id = :id";
            $data = $this->lireParamAsPrepared($this->sql . $where, array("id" => $id));
        }
        return $data;
    }

    /**
     * Surround of write function
     * Recording first the table station
     *
     * @param array $data
     * @return int
     */
    function ecrire(array $data)
    {
        require_once 'modules/classes/station.class.php';
        $station = new Station($this->connection, $this->paramori);
        $id = $station->ecrire($data);
        printr($id);
        if ($id > 0) {
            $data["station_id"] = $id;
            printr($data);
            return parent::ecrire($data);
        } else {
            return -1;
        }
    }
    /**
     * Get the list of the stations attached to a project
     *
     * @param int $project_id
     * @return array
     */
    function getListFromProject(int $project_id)
    {
        $where = " where project_id = :project_id";
        return $this->getListeParamAsPrepared($this->sql . $where, array("project_id" => $project_id));
    }
}
