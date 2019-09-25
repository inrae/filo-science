<?php
include_once 'modules/classes/antenna.class.php';
include_once 'modules/classes/station_tracking.class.php';
$dataClass = new Antenna($bdd, $ObjetBDDParam);
$stationTracking = new StationTracking($bdd, $ObjetBDDParam);
$keyName = "antenna_id";
$id = $_REQUEST[$keyName];
if (!$stationTracking->verifyProject($_REQUEST["station_id"])) {
    $message->set(_("La station ne fait partie d'un projet autorisé"), true);
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
} else {
    switch ($t_module["param"]) {
        case "change":
            $data = dataRead($dataClass, $id, "tracking/antennaChange.tpl", $_REQUEST["station_id"]);
            $vue->set($stationTracking->lire($_REQUEST["station_id"]), "station");
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
