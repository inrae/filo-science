<?php
include_once 'modules/classes/probe.class.php';
include_once 'modules/classes/station_tracking.class.php';
$dataClass = new Probe($bdd, $ObjetBDDParam);
$stationTracking = new StationTracking($bdd, $ObjetBDDParam);
$keyName = "probe_id";
$id = $_REQUEST[$keyName];
if (!$stationTracking->verifyProject($_REQUEST["station_id"])) {
    $message->set(_("La station ne fait partie d'un projet autorisé"), true);
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
} else {
    switch ($t_module["param"]) {
        case "change":
            $data = dataRead($dataClass, $id, "tracking/probeChange.tpl", $_REQUEST["station_id"]);
            $vue->set($stationTracking->lire($_REQUEST["station_id"]), "station");
            require_once "modules/classes/probe_parameter.class.php";
            $pp = new ProbeParameter($bdd, $ObjetBDDParam);
            $vue->set($pp->getListFromParent($id), "parameters");
            if (isset($_REQUEST["probe_parameter_id"])) {
                /**
                 * Create the form for the specified parameter
                 */
                $vue->set($pp->lire($_REQUEST["probe_parameter_id"],true, $id), "probe_parameter");
            }
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