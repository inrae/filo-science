<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

/**
 * individual_tracking ORM class
 */
class IndividualTracking extends PpciModel
{
    private $sql = "SELECT individual_id, release_station_id, transmitter_type_id, it.project_id, taxon_id
                    ,tag, tag_posed, transmitter, spaghetti_brand
                    , transmitter_type_name,transmitter_type_id
                    , individual_id as individual_uid
                    ,project_name
                    ,scientific_name
                    ,individual_code
                    ,uuid
                    ,array_to_string(year, ',') as year
                    , detection_count(individual_id) as nb_detections
                    from individual_tracking it
                    join individual using (individual_id)
                    join project p on (it.project_id = p.project_id)
                    join taxon using (taxon_id)
                    left outer join transmitter_type using (transmitter_type_id)
                    left outer join station_tracking on (station_id = release_station_id)
                    left outer join station using (station_id)";
    public $project_id;
    public Individual $individual;
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "individual_tracking";
        $this->fields = array(
            "individual_id" => array("type" => 1, "requis" => 1, "key" => 1),
            "release_station_id" => array("type" => 1),
            "transmitter_type_id" => array("type" => 1),
            "project_id" => array("type" => 1, "requis" => 1),
            "taxon_id" => array("type" => 1, "requis" => 1),
            "year" => array("type" => 0)
        );
        $this->useAutoIncrement = false;
        parent::__construct();
    }

    function read(int $id, $getDefault = true, $parentId = null): array {
        if ($id == 0 ) {
            return $this->getDefaultValues($parentId) ;
        } else {
            $where = " where individual_id = :id:";
            return $this->readParam($this->sql.$where, ["id"=>$id]);
        }
    }
    /**
     * Surround of ecrire, to write year in an array
     *
     * @param array $data
     * @return int|null
     */
    function write($data): int
    {
        $data["year"] = "{" . $data["year"] . "}";
        return parent::write($data);
    }
    /**
     * Get the list of individuals from project
     *
     * @param integer $project_id
     * @return array
     */
    function getListFromProject(int $project_id, int $year = 0, int $taxon_id = 0)
    {
        $where = " where it.project_id = :project_id:";
        $param = array("project_id" => $project_id);
        if ($year > 0) {
            $where .= " and :year: = any (year)";
            $param["year"] = $year;
        }
        if ($taxon_id > 0) {
            $where .= " and taxon_id = :taxon_id:";
            $param["taxon_id"] = $taxon_id;
        }
        return ($this->getListeParamAsPrepared($this->sql . $where, $param));
    }

    private function _getFromField(string $fieldname, string $value, int $project_id = 0)
    {
        if (empty($project_id) && !empty($this->project_id)) {
            $project_id = $this->project_id;
        }
        if (empty($project_id)) {
            throw new PpciException (sprintf(_("IndividualTracking-getFromField %s: le numéro de projet n'a pas été fourni"),$fieldname));
        }
        $where = " where $fieldname = :value: and it.project_id = :project_id:";
        return $this->lireParamAsPrepared(
            $this->sql . $where,
            array("value" => $value, "project_id" => $project_id)
        );
    }
    /**
     * Get the fish from the tag
     *
     * @param string $tag
     * @return array
     */
    function getFromTag(string $tag, int $project_id = 0)
    {
        return $this->_getFromField("tag", $tag, $project_id);
    }
    /**
     * Get the fish from the transmitter
     *
     * @param string $transmitter
     * @return void|string
     */
    function getFromTransmitter(string $transmitter, int $project_id = 0)
    {
        return $this->_getFromField("transmitter", $transmitter, $project_id);
    }

    /**
     * Get the fish from the individual_code
     *
     * @param string $code
     * @return void|string
     */
    function getFromCode(string $code, int $project_id = 0)
    {
        return $this->_getFromField("individual_code", $code, $project_id);
    }

    /**
     * Delete a tracking fish with children
     *
     * @param integer $id
     * @return void
     */
    function delete($id = null, $purge = false)
    {
        $detection = new Detection;
        $detection->deleteFromField($id, "individual_id");
        parent::delete($id);
    }

    /**
     * Set the current project_id
     *
     * @param int $project_id
     * @return void
     */
    function setProjectId(int $project_id)
    {
        if ($project_id > 0) {
            $this->project_id = $project_id;
        } else {
            throw new PpciException(_("Le numéro du projet n'est pas conforme"));
        }
    }
    /**
     * Get the detail of a fish
     *
     * @param integer $id
     * @return array
     */
    function getDetail(int $id)
    {
        $where = " where individual_id = :individual_id:";
        return $this->lireParamAsPrepared($this->sql . $where, array("individual_id" => $id));
    }

    /**
     * REturn all detections for an individual
     *
     * @param array|int $id
     * @param string $formatDate
     * @param string $orderBy
     * @return array
     */
    function getListDetection($uid, string $formatDate = 'YYYY-MM-DD HH24:MI:SS.MS', string $orderBy = "individual_id, detection_date", int $limit = 0, int $offset = 0, int $year = 0): array
    {
        if (empty($year)) {
            $year = 0;
        }
        $param = array("formatDate" => $formatDate);
        if (is_array($uid)) {
            $where = " individual_id in (";
            $comma = "";
            foreach ($uid as $id) {
                if (is_numeric($id)) {
                    $where .= $comma . $id;
                    $comma = ",";
                }
            }
            $where .= ")";
        } else {
            $where = " individual_id = :id:";
            $param["id"] = $uid;
        }
        if ($year > 0) {
            $where .= " and extract(year from detection_date) = :year:";
            $param["year"] = $year;
        }
        $sql = "
            select detection_id as id, individual_id, individual_code, scientific_name, to_char(detection_date, :formatDate:) as detection_date
                ,extract (epoch from detection_date) as date_epoch
                , nb_events, duration, validity, signal_force, observation
                ,station_long long, station_lat lat, station_name, station_code, station_number
                ,'stationary' as detection_type
                ,antenna_code, antenna_id
            from detection
            join antenna using (antenna_id)
            join station using (station_id)
            join individual_tracking using (individual_id)
            join individual using (individual_id)
            join taxon using (taxon_id)
            where $where
            union
            select location_id as id, individual_id, individual_code, scientific_name, to_char(detection_date, :formatDate:) as detection_date
                ,extract (epoch from detection_date) as date_epoch
                , null nb_events, null duration, true validity, signal_force, observation
                , location_long long, location_lat lat, null station_name, null station_code, null station_number
                ,'mobile' as detection_type
                ,null as antenna_code, null as antenna_id
            from location
            join individual_tracking using (individual_id)
            join individual using (individual_id)
            join taxon using (taxon_id)
            where $where
        ";

        $sql = "with req as (" . $sql . ") select * from req order by $orderBy";
        if ($limit > 0) {
            $sql .= " limit :limit: offset :offset:";
            $param["limit"] = $limit;
            $param["offset"] = $offset;
        }
        return $this->getListeParamAsPrepared($sql, $param);
    }

    /**
     * Get the individual_id of a fish, searched from a field, with or without the project_id
     *
     * @param string $field
     * @param any $value
     * @param integer $project_id
     * @return int: individual_id or 0
     */
    function getIdFromField(string $field, $value, $project_id = 0): int
    {
        $id = 0;
        if (!empty($value)) {
            $sql = "SELECT individual_id from individual_tracking
            join individual using (individual_id)
            where $field = :val:";
            $param = array("val" => $value);
            if ($project_id > 0 && $field != "uuid") {
                $sql .= " and project_id = :project_id:";
                $param["project_id"] = $project_id;
            }
            $data = $this->lireParamAsPrepared($sql, $param);
            if ($data["individual_id"] > 0) {
                $id = $data["individual_id"];
            }
        }
        return $id;
    }
    /**
     * Get the list of fish not associated with a sequence
     *
     * @param integer $project_id
     * @return array|null
     */
    function getListNotInSequence(int $project_id): ?array
    {
        $where = " where it.project_id = :project_id: and sample_id is null";
        return $this->getListeParamAsPrepared($this->sql . $where, array("project_id" => $project_id));
    }
    /**
     * Get the list of individuals from an array contains a list of individual_id
     *
     * @param array $uids
     * @return array|null
     */
    function getListFromUids(array $uids): ?array
    {
        $isComma = false;
        $i = 0;
        $param = [];
        $where = " where individual_id in (";
        foreach ($uids as $uid) {
            if (is_numeric($uid) && $uid > 0) {
                $isComma ? $where .= "," : $isComma = true;
                $where .= ":uid$i:";
                $param["uid$i"] = $uid;
                $i++;
            }
        }
        $where .= ")";
        $order = " order by scientific_name, individual_code";
        return $this->getListeParam($this->sql . $where . $order, $param);
    }

    /**
     * Get the number of detections for a fish, by date and by day part  (night, day)
     *
     * @param integer $individual_id
     * @return array|null
     */
    function getDetectionNumberByDate(int $individual_id, int $year = 0): ?array
    {
        $sql = "SELECT * from crosstab (
      'select detection_date::date, daypart, count(*) as nb
      from tracking.detection";
        $where = " where individual_id = :id:";
        $param["id"] = $individual_id;
        $group = " group by detection_date::date, daypart
      order by detection_date::date',
      E'select unnest(array[\'d\',\'n\',\'u\'])')
      as
      (detection_date date, day int, night int, unknown int)";
        $this->fields["detection_date"] = array("type" => 2);
        if ($year > 0) {
            $where .= " and extract(year from detection_date) = :year:";
            $param["year"] = $year;
        }
        $list = $this->getListeParam($sql . $where . $group, $param);
        $cols = array("day", "night", "unknown");
        foreach ($list as $k => $v) {
            foreach ($cols as $c) {
                if (empty($v[$c])) {
                    $list[$k][$c] = 0;
                }
            }
        }
        return $list;
    }

    /**
     * Get the detections grouped by station
     *
     * @param integer $individual_id
     * @param int $year
     * @return array
     */
    function getStationDetection(int $individual_id, int $year = 0): array
    {
        $data = $this->getListDetection($individual_id, 'YYYY-MM-DD HH24:MI:SS.MS', "detection_date", 0, 0, $year);
        $result = array();
        $antennas = array();
        foreach ($data as $row) {
            $current_antenna = $row["antenna_id"];

            /**
             * search for antenna waitings
             */
            foreach ($antennas as $ka => $antenna) {
                if ($ka != $current_antenna) {
                    if ($row["date_epoch"] - $antenna["epoch"] > 1200) {
                        $result[] = $antenna["content"];
                        unset($antennas[$ka]);
                    }
                }
            }
            if (!isset($antennas[$current_antenna])) {
                $antennas[$current_antenna]["content"]["individual_id"] = $row["individual_id"];
                $antennas[$current_antenna]["content"]["antenna_id"] = $current_antenna;
                $antennas[$current_antenna]["content"]["date_from"] = $row["detection_date"];
                $antennas[$current_antenna]["content"]["station_id"] = $row["station_id"];
                $antennas[$current_antenna]["content"]["station_name"] = $row["station_name"];
                $antennas[$current_antenna]["content"]["antenna_code"] = $row["antenna_code"];
                $antennas[$current_antenna]["content"]["detection_type"] = $row["detection_type"];
                $antennas[$current_antenna]["content"]["lat"] = $row["lat"];
                $antennas[$current_antenna]["content"]["long"] = $row["long"];
                $antennas[$current_antenna]["content"]["nb_events"] = 1;
                $antennas[$current_antenna]["content"]["last_date"] = $row["detection_date"];
                $antennas[$current_antenna]["epoch"] = $row["date_epoch"];
                $antennas[$current_antenna]["wait"] = 1;
            } else {
                $antennas[$current_antenna]["content"]["last_date"] = $row["detection_date"];
                $antennas[$current_antenna]["content"]["nb_events"]++;
            }
        }
        /**
         * Last items
         */
        foreach ($antennas as $ka => $antenna) {
            $result[] = $antenna["content"];
        }
        return $result;
    }
    /**
     * Get the list of taxa used in a project
     *
     * @param integer $project_id
     * @return array|null
     */
    function getListTaxaFromProject(int $project_id): ?array
    {
        $sql = "SELECT distinct taxon_id, scientific_name
        from individual_tracking
        join taxon using (taxon_id)
        where project_id = :project_id:
        order by scientific_name";
        return $this->getListeParamAsPrepared($sql, array("project_id" => $project_id));
    }
    /**
     * Get the list of years calculating from the individuals from the project
     *
     * @param integer $project_id
     * @return array|null
     */
    function getListYearFromProject(int $project_id): ?array
    {
        $sql = "SELECT distinct unnest (year) as year
        from individual_tracking
        where project_id = :project_id:
        order by unnest(year)
    ";
        return $this->getListeParamAsPrepared($sql, array("project_id" => $project_id));
    }
}
