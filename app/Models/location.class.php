<?php 
namespace App\Models;
use Ppci\Models\PpciModel;

/**
 * ORM of the table location
 */
class Location extends PpciModel
{
  /**
   * Constructor
   *
   * @param 
   * @param array $param
   */
  function __construct()
  {
    $this->table = "location";
    $this->srid = 4326;
    $this->fields = array(
      "location_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "individual_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
      "antenna_type_id" => array("type" => 1),
      "detection_date" => array("type" => 3, "requis" => 1, "defaultValue" => "getDateHeure"),
      "location_pk" => array("type" => 1),
      "location_long" => array("type" => 1),
      "location_lat" => array("type" => 1),
      "signal_force" => array("type" => 1),
      "observation" => array("type" => 0),
      "geom" => array("type" => 4)
    );
    parent::__construct();
  }

  /**
   * Add the generation of the geom point to the location
   *
   * @param array $data
   * @return int
   */
  function write( $data): int
  {
    if (!empty($data["location_long"]) && !empty($data["location_lat"]) ) {
      $data["geom"] = "POINT(" . $data["location_long"] . " " . $data["location_lat"] . ")";
    } else {
      $data["geom"] = "";
    }
    return parent::write($data);
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
    if ($rewriteMode) {
      $sql = "select location_id from location where individual_id = :individual_id
              and detection_date = :detection_date";
      $databefore = $this->lireParamAsPrepared($sql, array(
        "individual_id" => $data["individual_id"],
        "detection_date" => $data["detection_date"]
      ));
      if ($databefore["location_id"] > 0) {
        $data["location_id"] = $databefore["location_id"];
      }
    }
    return parent::write($data);
  }
}
