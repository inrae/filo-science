<?php

use function Safe\date_sunset;

/**
 * ORM of table detection
 */
class Detection extends ObjetBDD
{

  public Antenna $antenna;
  private $dataAntenna;
  private $currentDate;
  private $sunset;
  private $sunrise;

  private $sql = "select detection_id, individual_id, antenna_id,
                  to_char(detection_date, :formatDate) as detection_date,
                  extract (epoch from detection_date) as date_epoch,
                  nb_events, duration, validity, signal_force, observation, daypart,
                  antenna_code, station_id, station_name, station_code, station_number,
                  station_long long, station_lat lat,
                  project_id
                  from detection
                  join antenna using (antenna_id)
                  join station using (station_id)";
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
      "detection_date" => array("type" => 3),
      "nb_events" => array("type" => 1),
      "duration" => array("type" => 1),
      "validity" => array("type" => 1),
      "signal_force" => array("type" => 1),
      "observation" => array("type" => 0),
      "daypart" => array("type" => 0)
    );
    parent::__construct($bdd, $param);
  }
  /**
   * Get the list of detections for a fish with the formatted date
   *
   * @param int $id
   * @param string $formatDate
   * @param int $year
   * @return array
   */
  function getListFromIndividual(int $id, $formatDate = 'YYYY-MM-DD HH24:MI:SS.MS', $year = 0)
  {
    $this->auto_date = 0;
    $where = " where individual_id = :individual_id";
    $param = array("individual_id" => $id, "formatDate" => $formatDate);
    $order = " order by detection_date";
    if ($year > 0) {
      $where .= " and extract (year from detection_date) = :year";
      $param["year"] = $year;
    }
    return $this->getListeParamAsPrepared($this->sql . $where . $order, $param);
  }
  /**
   * Import data from file
   *
   * @param array $data
   * @param boolean $rewriteMode
   * @return void
   */
  function importData(array $data, bool $rewriteMode = false)
  {
    if (!isset($this->antenna)) {
      $this->antenna = $this->classInstanciate("Antenna", "tracking/antenna.class.php");
    }
    if ($rewriteMode) {
      $sql = "select detection_id from detection where individual_id = :individual_id
                    and antenna_id = :antenna_id and detection_date = :detection_date";
      $databefore = $this->lireParamAsPrepared($sql, array(
        "individual_id" => $data["individual_id"],
        "antenna_id" => $data["antenna_id"],
        "detection_date" => $data["detection_date"]
      ));
      if ($databefore["detection_id"] > 0) {
        $data["detection_id"] = $databefore["detection_id"];
      }
    }
    $date = new DateTime($data["detection_date"]);
    $dateTimestamp = $date->gettimestamp();
    if ($this->dataAntenna["antenna_id"] != $data["antenna_id"]) {
      $this->dataAntenna = $this->antenna->lire($data["antenna_id"]);
    }
    if (substr($data["detection_date"], 10) != $this->currentDate) {
      /**
       * Calculate the sunrise and the sunset
       */
      $this->currentDate = substr($data["detection_date"], 10);
      $sun = date_sun_info($dateTimestamp, $this->dataAntenna["station_lat"], $this->dataAntenna["station_long"]);
      /*$this->sunset = date_sunset($dateTimestamp, SUNFUNCS_RET_TIMESTAMP, $this->dataAntenna["station_lat"], $this->dataAntenna["station_long"]);
      $this->sunrise = date_sunrise($dateTimestamp, SUNFUNCS_RET_TIMESTAMP, $this->dataAntenna["station_lat"], $this->dataAntenna["station_long"]);
    */
    }
    if ($dateTimestamp >= $sun["sunrise"] && $dateTimestamp <= $sun["sunset"]) {
      $data["daypart"] = "d";
    } else {
      $data["daypart"] = "n";
    }
    return parent::ecrire($data);
  }
  /**
   * Calculate the duration of presence of a fish in each station
   *
   * @param integer $individual_id
   * @param int $year
   * @return array
   */
  function getStationDetection(int $individual_id, $time_to_group_detection = 1200, $year = 0): array
  {
    $data = $this->getListFromIndividual($individual_id, 'YYYY-MM-DD HH24:MI:SS.MS', $year);
    $result = array();
    $last_antenna = 0;
    $current_row = array();
    $last_date = "";
    $nb_events = 0;
    $fields = array("individual_id", "antenna_id", "station_id", "station_name", "antenna_code", "long", "lat", "station_number", "station_code");
    $antennas = array();
    $current_antenna = 0;
    foreach ($data as $row) {
      $current_antenna = $row["antenna_id"];

        /**
         * search for antenna waitings
         */
        foreach ($antennas as $ka => $antenna) {
          if ($ka != $current_antenna) {
            if ($row["date_epoch"] - $antenna["epoch"] > $time_to_group_detection) {
              $result[] = $antenna["content"];
              unset ($antennas[$ka]);
            }
          }
        }
      if (!isset($antennas[$current_antenna])) {
        foreach ($fields as $field) {
          $antennas[$current_antenna]["content"][$field] = $row[$field];
        }
        $antennas[$current_antenna]["content"]["date_from"] = $row["detection_date"];
        $antennas[$current_antenna]["content"]["nb_events"] = 1;
        $antennas[$current_antenna]["content"]["date_to"] = $row["detection_date"];
        $antennas[$current_antenna]["epoch"] = $row["date_epoch"];
        $antennas[$current_antenna]["wait"] = 1;
      } else {
        $antennas[$current_antenna]["content"]["date_to"] = $row["detection_date"];
        $antennas[$current_antenna]["content"]["nb_events"] ++;
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
   * Recalculate the position of the detection in the day (day/night)
   *
   * @param integer $project_id
   * @return integer
   */
  function calculateGlobalSunPeriod(int $project_id, $formatDate = 'YYYY-MM-DD HH24:MI:SS.MS'): int
  {
    /**
     * Calculate the total number of items
     */
    $sql = "select count(*) as nb
            from detection
            join antenna using (antenna_id)
            join station using (station_id)
            where project_id = :project_id";
    $res = $this->lireParamAsPrepared($sql, array("project_id" => $project_id));
    $nbOccurs = intval($res["nb"] / 100000);
    $nbItems = 0;
    $sql = $this->sql . " where project_id =:project_id order by antenna_id, detection_date limit 100000 offset :offset";
    if (!isset($this->antenna)) {
      $this->antenna = $this->classInstanciate("Antenna", "tracking/antenna.class.php");
    }
    $this->colonnes["validity"]["type"] = 0;
    for ($i = 0; $i <= $nbOccurs; $i++) {
      $this->connection->beginTransaction();
      $offset = ($i * 100000) + 1;
      $data = $this->getListeParamAsPrepared($sql, array("project_id" => $project_id, "formatDate" => $formatDate, "offset" => $offset));
      foreach ($data as $row) {
        $nbItems++;
        $date = new DateTime($row["detection_date"]);
        $dateTimestamp = $date->gettimestamp();
        if ($this->dataAntenna["antenna_id"] != $row["antenna_id"]) {
          $this->dataAntenna = $this->antenna->lire($row["antenna_id"]);
        }
        if (substr($row["detection_date"], 10) != $this->currentDate) {
          /**
           * Calculate the sunrise and the sunset
           */
          $this->currentDate = substr($row["detection_date"], 10);
          $this->sunset = date_sunset($dateTimestamp, SUNFUNCS_RET_TIMESTAMP, $this->dataAntenna["station_lat"], $this->dataAntenna["station_long"]);
          $this->sunrise = date_sunrise($dateTimestamp, SUNFUNCS_RET_TIMESTAMP, $this->dataAntenna["station_lat"], $this->dataAntenna["station_long"]);
        }
        if ($dateTimestamp >= $this->sunrise && $dateTimestamp <= $this->sunset) {
          $row["daypart"] = "d";
        } else {
          $row["daypart"] = "n";
        }
        $this->ecrire($row);
      }
      $this->connection->commit();
    }
    return $nbItems;
  }
}
