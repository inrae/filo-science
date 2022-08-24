<?php
class IndividualTrackingException extends Exception
{
}

/**
 * individual_tracking ORM class
 */
class IndividualTracking extends ObjetBDD
{
  private $sql = "select individual_id, release_station_id, transmitter_type_id, it.project_id, taxon_id
                    ,tag, transmitter, spaghetti_brand
                    , transmitter_type_name
                    , individual_id as individual_uid
                    ,project_name
                    ,scientific_name
                    ,individual_code
                    ,uuid
                    ,array_to_string(year, ',') as year
                    from individual_tracking it
                    join individual using (individual_id)
                    join project p on (it.project_id = p.project_id)
                    join taxon using (taxon_id)
                    left outer join transmitter_type using (transmitter_type_id)
                    left outer join station_tracking on (station_id = release_station_id)
                    left outer join station using (station_id)";
  public $project_id;
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
      "taxon_id" => array("type" => 1, "requis" => 1),
      "year" => array("type" => 0)
    );
    $this->id_auto = 0;
    parent::__construct($bdd, $param);
  }
  /**
   * Surround of ecrire, to write year in an array
   *
   * @param array $data
   * @return int|null
   */
  function ecrire($data)
  {
    $data["year"] = "{" . $data["year"] . "}";
    return parent::ecrire($data);
  }
  /**
   * Get the list of individuals from project
   *
   * @param integer $project_id
   * @return array
   */
  function getListFromProject(int $project_id, int $year = 0, int $taxon_id = 0)
  {
    $where = " where it.project_id = :project_id";
    $param = array("project_id" => $project_id);
    if ($year > 0) {
      $where .= " and :year = any (year)";
      $param["year"] = $year;
    }
    if ($taxon_id > 0) {
      $where .= " and taxon_id = :taxon_id";
      $param["taxon_id"] = $taxon_id;
    }
    return ($this->getListeParamAsPrepared(
      $this->sql . $where,
      $param
    ));
  }

  private function _getFromField(string $fieldname, string $value, int $project_id = 0)
  {
    if ($project_id == 0) {
      $project_id = $this->project_id;
    }
    $where = " where $fieldname = :value and it.project_id = :project_id";
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
  function supprimer(int $id)
  {
    include_once "modules/classes/tracking/detection.class.php";
    $detection = new Detection($this->connection, $this->paramori);
    $detection->supprimerChamp($id, "individual_id");
    parent::supprimer($id);
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
      throw new IndividualTrackingException(_("Le numéro du projet n'est pas conforme"));
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
    $where = " where individual_id = :individual_id";
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
      $where = " individual_id = :id";
      $param["id"] = $uid;
    }
    if ($year > 0) {
      $where .= " and extract(year from detection_date) = :year";
      $param["year"] = $year;
    }
    $sql = "
            select detection_id as id, individual_id, individual_code, scientific_name, to_char(detection_date, :formatDate) as detection_date
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
            select location_id as id, individual_id, individual_code, scientific_name, to_char(detection_date, :formatDate) as detection_date
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
      $sql .= " limit $limit offset $offset";
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
      $sql = "select individual_id from individual_tracking
            join individual using (individual_id)
            where $field = :value";
      $param = array("value" => $value);
      if ($project_id > 0 && $field != "uuid") {
        $sql .= " and project_id = :project_id";
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
    $where = " where it.project_id = :project_id and sample_id is null";
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
    $where = " where individual_id in (";
    foreach ($uids as $uid) {
      if (is_numeric($uid) && $uid > 0) {
        $isComma ? $where .= "," : $isComma = true;
        $where .= $uid;
      }
    }
    $where .= ")";
    $order = " order by scientific_name, individual_code";
    return $this->getListeParam($this->sql . $where . $order);
  }

  /**
   * Get the number of detections for a fish, by date and by day part  (night, day)
   *
   * @param integer $individual_id
   * @return array|null
   */
  function getDetectionNumberByDate(int $individual_id, int $year = 0): ?array
  {
    $sql = "select * from crosstab (
      'select detection_date::date, daypart, count(*) as nb
      from tracking.detection";
    $where = " where individual_id = $individual_id";
    $group = " group by detection_date::date, daypart
      order by detection_date::date',
      E'select unnest(array[\'d\',\'n\',\'u\'])')
      as
      (detection_date date, day int, night int, unknown int)";
    $this->colonnes["detection_date"] = array("type" => 2);
    if ($year > 0) {
      $where .= " and extract(year from detection_date) = $year";
    }
    return $this->getListeParam($sql . $where . $group);
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
    $last_antenna = 0;
    $current_row = array();
    $last_date = "";
    $nb_events = 0;
    foreach ($data as $row) {
      if ($row["antenna_id"] != $last_antenna) {
        if (!empty($current_row)) {
          $current_row["date_to"] = $last_date;
          $current_row["nb_events"] = $nb_events;
          $result[] = $current_row;
          $current_row = array();
        }
        $current_row["individual_id"] = $row["individual_id"];
        $current_row["antenna_id"] = $row["antenna_id"];
        $current_row["date_from"] = $row["detection_date"];
        $current_row["station_id"] = $row["station_id"];
        $current_row["station_name"] = $row["station_name"];
        $current_row["antenna_code"] = $row["antenna_code"];
        $current_row["detection_type"] = $row["detection_type"];
        $current_row["lat"] = $row["lat"];
        $current_row["long"] = $row["long"];
        $last_antenna = $row["antenna_id"];
        $last_date = $row["detection_date"];
        $nb_events = 1;
      } else {
        $nb_events++;
      }
    }
    /**
     * Last item
     */
    if (!empty($current_row)) {
      $current_row["date_to"] = $last_date;
      $current_row["nb_events"] = $nb_events;
      $result[] = $current_row;
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
    $sql = "select distinct taxon_id, scientific_name
        from individual_tracking
        join taxon using (taxon_id)
        where project_id = :project_id
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
    $sql = "select distinct unnest (year) as year
        from individual_tracking
        where project_id = :project_id
        order by unnest(year)
    ";
    return $this->getListeParamAsPrepared($sql, array("project_id" => $project_id));
  }
}
