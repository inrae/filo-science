<?php
include_once 'modules/classes/tracking/detection.class.php';
$dataClass = new Detection($bdd, $ObjetBDDParam);
$dataClass->auto_date = 0;
include_once "modules/classes/tracking/individual_tracking.class.php";
$individualTracking = new IndividualTracking($bdd, $ObjetBDDParam);

$keyName = "detection_id";
$id = $_REQUEST[$keyName];
/**
 * Verifiy the project
 */
if ($t_module["param"] != "calculateSunPeriod" && $t_module["param"] != "calculateSunPeriodExec") {
  if ($id > 0) {
    $data = $dataClass->lire($id);
    $individual_id = $data["individual_id"];
  } else {
    $individual_id = $_REQUEST["individual_id"];
  }
  $dindividual = $individualTracking->getDetail($individual_id);
  if (!verifyProject($dindividual["project_id"])) {
    $module_coderetour = -1;
  }
}
if ($module_coderetour != -1) {
  switch ($t_module["param"]) {
    case "change":
      if ($id == 0) {
        $data = $dataClass->getDefaultValue($individual_id);
      }
      $vue->set($data, "data");
      $vue->set("tracking/detectionChange.tpl", "corps");
      $vue->set($dindividual, "individual");
      /**
       * Get the list of antennas and locations
       */
      include_once "modules/classes/tracking/antenna.class.php";
      $antenna = new Antenna($bdd, $ObjetBDDParam);
      $vue->set($antenna->getListFromProject($dindividual["project_id"]), "antennas");
      include_once "modules/classes/tracking/location.class.php";
      //$location = new Location($bdd, $ObjetBDDParam);
      //$vue->set($location->getListFromProject($dindividual["project_id"]), "locations");
      break;
    case "write":
      /**
       * write record in database
       */
      $id = dataWrite($dataClass, $_REQUEST);
      if ($id > 0) {
        $_REQUEST[$keyName] = $id;
      }
      break;
    case "delete":
      /**
       * delete record
       */
      dataDelete($dataClass, $id);
      break;
    case "calculateSunPeriod":
      $vue->set("tracking/detectionRecalculate.tpl", "corps");
      $vue->set($_SESSION["projects"], "projects");
      break;
    case "calculateSunPeriodExec":
      if (verifyProject($_REQUEST["project_id"])) {
        try {
          $nb = $dataClass->calculateGlobalSunPeriod($_REQUEST["project_id"]);
          $message->set(sprintf(_("Recalcul effectué, %s détections traitées"), $nb));
          $module_coderetour = 1;
        } catch (Exception $e) {
          $message->set(_("Une erreur est survenue pendant l'opération"), true);
          $message->set($e->getMessage());
          $module_coderetour = -1;
        }
      }
      break;
  }
}
