<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class StationTracking extends PpciModel
{
    private $sql = "SELECT station_id, station_name, project_id, project_name, metric_srid,
            station_long, station_lat, station_pk, river_id, river_name,station_code,station_number,
            station_type_id, station_type_name, station_active
            from station_tracking
            join station using (station_id)
            join station_type using (station_type_id)
            left outer join river using (river_id)
            left outer join project using (project_id)
            ";
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "station_tracking";
        $this->fields = array(
            "station_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "station_type_id" => array("type" => 1, "requis" => 1),
            "station_active" => array("type" => 1)
        );
        $this->useAutoIncrement = false;
        parent::__construct();
    }
    /**
     * Surcharge pour rajouter les infos de la table station
     *
     * @param int $id
     * @return array
     */
    function read($id, $getDefault = true, $parentValue = 0): array
    {
        if ($id == 0) {
            $data = $this->getDefaultValues();
        } else {
            $where = " where station_id = :id:";
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
    function write($data): int
    {
        $station = new Station;
        $id = $station->write($data);
        if ($id > 0) {
            $data["station_id"] = $id;
            return parent::write($data);
        } else {
            return -1;
        }
    }
    /**
     * Get the list of the stations attached to a project
     *
     * @param int $project_id
     * @param int $station_type_id
     * @param bool $is_active
     * @return array
     */
    function getListFromProject(int $project_id, int $station_type_id = 0, bool $onlyActive = false)
    {
        $where = " where project_id = :project_id:";
        $params = array("project_id" => $project_id);
        if ($station_type_id > 0) {
            $where .= " and station_type_id = :station_type_id:";
            $params["station_type_id"] = $station_type_id;
        }
        if ($onlyActive) {
            $where .= " and station_active = true";
        }
        $order = " order by station_number";
        return $this->getListeParamAsPrepared($this->sql . $where . $order, $params);
    }
    /**
     * Get the detail of a station
     *
     * @param integer $station_id
     * @return array
     */
    function getDetail(int $station_id)
    {
        $where = " where station_id = :id:";
        return $this->lireParamAsPrepared($this->sql . $where, array("id" => $station_id));
    }

    /**
     * Verify if the station is authorized in the project
     *
     * @param integer $station_id
     * @return boolean
     */
    function verifyProject(int $station_id): bool
    {
        $data = $this->read($station_id);
        helper("filo");
        return (\App\Libraries\verifyProject($data["project_id"]));
    }
    /**
     * Get the list of antennas or probes according to the type of import
     *
     * @param integer $project_id
     * @param integer $import_type_id
     * @return array
     */
    function getListSensor(int $project_id, int $import_type_id)
    {
        $this->fields["date_from"] = array("type" => 2);
        $this->fields["date_to"] = array("type" => 2);
        switch ($import_type_id) {
            case 1:
                $sql = "SELECT antenna_id as sensor_id, station_name, station_code, antenna_code as sensor_code, date_from, date_to
                    from station_tracking
                    join antenna using (station_id)
                    join station using (station_id)
                    where project_id = :project_id:";
                break;
            case 2:
                $sql = "SELECT probe_id as sensor_id, station_name, station_code, probe_code as sensor_code, date_from, date_to
                    from station_tracking
                    join probe using (station_id)
                    join station using (station_id)
                    where project_id = :project_id:";
                break;

            default:
                return (array());
        }
        return $this->getListeParamAsPrepared($sql, array("project_id" => $project_id));
    }

    /**
     * Get the list of dates of presence of a station between dates
     *
     * @param integer $project_id
     * @param float $station_number
     * @param string $date_from
     * @param string $date_to
     * @return array
     */
    function getPresenceStation(int $project_id, float $station_number, string $date_from = "", string $date_to = ""): ?array
    {
        $sql = "SELECT station_id, station_number, antenna_id, antenna_code, date_from, date_to
                from station_tracking
                join antenna using (station_id)
                join station using (station_id)
                where station_number = :station_number:
                and project_id = :project_id:";
        if (!empty($date_from) && !empty($date_to)) {
            $sql .= " and (TIMESTAMP '$date_from', TIMESTAMP '$date_to') overlaps (date_from, date_to)";
        }
        $sql .= " order by date_from";
        return $this->getListeParamAsPrepared($sql, array("project_id" => $project_id, "station_number" => $station_number));
    }
}
