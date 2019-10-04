<?php

include_once 'modules/classes/tracking/probe_parameter.class.php';
include_once 'modules/classes/tracking/station_tracking.class.php';
$dataClass = new ProbeParameter($bdd, $ObjetBDDParam);
$stationTracking = new StationTracking($bdd, $ObjetBDDParam);
$keyName = "probe_id";
$id = $_REQUEST[$keyName];
if (!$stationTracking->verifyProject($_REQUEST["station_id"])) {
    $message->set(_("La station ne fait partie d'un projet autorisé"), true);
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
} else {
    switch ($t_module["param"]) {
        case "write":
            /**
             * write record in database
             */
            $id = dataWrite($dataClass, $_REQUEST);
            if ($id > 0) {
                unset($_REQUEST[$keyName]);
            }
            break;
        case "delete":
            /**
             * delete record
             */
            dataDelete($dataClass, $id);
            unset($_REQUEST[$keyName]);
            break;
    }
}
