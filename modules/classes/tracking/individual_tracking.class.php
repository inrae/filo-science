<?php
class IndividualTrackingException extends Exception
{ }

/**
 * individual_tracking ORM class
 */
class IndividualTracking extends ObjetBDD
{
  private $sql = "select individual_id, release_station_id, transmitter_type_id, it.project_id, taxon_id
                    ,tag, transmitter
                    , transmitter_type_name
                    ,project_name
                    ,scientific_name
                    ,individual_code
                    ,uuid
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
      "taxon_id" => array("type" => 1, "requis" => 1)
    );
    $this->id_auto = 0;
    parent::__construct($bdd, $param);
  }
  /**
   * Get the list of individuals from project
   *
   * @param integer $project_id
   * @return array
   */
  function getListFromProject(int $project_id)
  {
    $where = " where it.project_id = :project_id";
    return ($this->getListeParamAsPrepared($this->sql . $where, array("project_id" => $project_id)));
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
  function getListDetection($uid, string $formatDate = 'YYYY-MM-DD HH24:MI:SS.MS', string $orderBy = ""): array
  {
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
    $sql = "
            select detection_id as id, individual_id, scientific_name, to_char(detection_date, :formatDate) as detection_date
                , nb_events, duration, validity, signal_force, observation
                ,station_long long, station_lat lat, station_name, station_code, station_number
                ,'stationary' as detection_type
            from detection
            join antenna using (antenna_id)
            join station using (station_id)
            join individual_tracking using (individual_id)
            join taxon using (taxon_id)
            where $where
            union
            select location_id as id, individual_id, scientific_name, to_char(detection_date, :formatDate) as detection_date
                , null nb_events, null duration, true validity, signal_force, observation
                , location_long, location_lat, null station_name, null station_code, null station_number
                ,'mobile' as detection_type
            from location
            join individual_tracking using (individual_id)
            join taxon using (taxon_id)
            where $where
        ";
    if (strlen($orderBy) > 0) {
      $sql = "with req as (" . $sql . ") select * from req order by $orderBy";
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
    if (strlen($value) > 0) {
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
}
