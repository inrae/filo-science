<?php

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
   * @return array
   */
  function getListFromIndividual(int $id, $formatDate = 'YYYY-MM-DD HH24:MI:SS.MS')
  {
    $this->auto_date = 0;
    $sql = "select detection_id, individual_id, antenna_id, to_char(detection_date, :formatDate) as detection_date, nb_events, duration, validity, signal_force, observation
                from detection
                where individual_id = :individual_id";
    return $this->getListeParamAsPrepared($sql, array("individual_id" => $id, "formatDate" => $formatDate));
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
      $this->sunset = date_sunset($dateTimestamp, SUNFUNCS_RET_TIMESTAMP, $this->dataAntenna["station_lat"], $this->dataAntenna["station_long"]);;
      $this->sunrise = date_sunrise($dateTimestamp, SUNFUNCS_RET_TIMESTAMP, $this->dataAntenna["station_lat"], $this->dataAntenna["station_long"]);
    }
    if ($dateTimestamp >= $this->sunrise && $dateTimestamp <= $this->sunset) {
      $data["daypart"] = "d";
    } else {
      $data["daypart"] = "n";
    }
    return parent::ecrire($data);
  }


}
