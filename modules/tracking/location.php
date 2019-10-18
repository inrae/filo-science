<?php
include_once 'modules/classes/tracking/location.class.php';
$dataClass = new Location($bdd, $ObjetBDDParam);
$dataClass->auto_date = 0;
include_once "modules/classes/tracking/individual_tracking.class.php";
$individualTracking = new IndividualTracking($bdd, $ObjetBDDParam);

$keyName = "location_id";
$id = $_REQUEST[$keyName];
/**
 * Verifiy the project
 */
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

if ($module_coderetour != -1) {
    switch ($t_module["param"]) {
        case "change":
            if ($id == 0) {
                $data = $dataClass->getDefaultValue($individual_id);
            }
            $vue->set($data, "data");
            $vue->set("tracking/locationChange.tpl", "corps");
            $vue->set($dindividual, "individual");
            include_once "modules/classes/param.class.php";
            $param = new Param($bdd, "antenna_type");
            $vue->set($param->getListe("antenna_type_name"), "antennas");            
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
    }
}