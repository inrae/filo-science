<?php
include_once 'modules/classes/tracking/station_tracking.class.php';
$dataClass = new StationTracking($bdd, $ObjetBDDParam);
$keyName = "station_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        include_once 'modules/classes/project.class.php';
        $project = new Project($bdd, $ObjetBDDParam);
        isset($_COOKIE["projectId"]) ? $project_id = $_COOKIE["projectId"] : $project_id = 0;
        isset($_COOKIE["projectActive"]) ? $is_active = $_COOKIE["projectActive"] : $is_active = 1;
        $vue->set($projects = $project->getProjectsActive($is_active, $_SESSION["projects"]), "projects");
        if ($project_id > 0 && !verifyProject($project_id)) {
            $project_id = $projects[0]["project_id"];
        }
        if (!$project_id > 0) {
            $project_id = $projects[0]["project_id"];
        }
        $_COOKIE["stationActive"] == 1 ? $stationActive = true : $stationActive = false;
        $vue->set($dataClass->getListFromProject($project_id, 0, $stationActive), "stations");
        $vue->set("tracking/stationTrackingList.tpl", "corps");
        break;
    case "display":
        $vue->set($dataClass->getDetail($id), "data");
        $vue->set("tracking/stationTrackingDisplay.tpl", "corps");
        setParamMap($vue, false);
        /**
         * Get antennas
         */
        require_once "modules/classes/tracking/antenna.class.php";
        $antenna = new Antenna($bdd, $ObjetBDDParam);
        $vue->set($antenna->getListFromParent($id, "antenna_code"), "antennas");
        /**
         * Get probes
         */
        require_once 'modules/classes/tracking/probe.class.php';
        $probe = new Probe($bdd, $ObjetBDDParam);
        $vue->set($probe->getListFromParent($id), "probes");
        if (isset($_REQUEST["probe_id"])) {
            /**
             * Get the last measures for the probe
             */
            include_once "modules/classes/tracking/probe_measure.class.php";
            $pm = new ProbeMeasure($bdd, $ObjetBDDParam);

            if (!isset($_REQUEST["limit"])) {
                $_REQUEST["limit"] = 30;
            }
            if (!isset($_REQUEST["offset"]) || $_REQUEST["offset"] < 0) {
                $_REQUEST["offset"] = 0;
            }
            $vue->set($pm->getMeasures($_REQUEST["probe_id"], $_REQUEST["limit"], $_REQUEST["offset"]), "measures");
            $vue->set($_REQUEST["limit"], "limit");
            $vue->set($_REQUEST["offset"], "offset");
            $vue->set($_REQUEST["probe_id"], "selectedProbe");
        }
        break;
    case "change":
        /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
        $data = dataRead($dataClass, $id, "tracking/stationTrackingChange.tpl");
        if ($id == 0 && isset($_COOKIE["project_id"])) {
            $data["project_id"] = $_COOKIE["project_id"];
            $vue->set($data, "data");
        }
        $vue->set($_SESSION["projects"], "projects");
        include_once 'modules/classes/param.class.php';
        $stationType = new Param($bdd, "station_type");
        $vue->set($stationType->getListe(1), "stationsType");
        require_once 'modules/classes/param.class.php';
        $river = new Param($bdd, "river");
        $vue->set($river->getListe("river_name"), "rivers");
        setParamMap($vue, true);
        break;
    case "write":
        /**
         * Verify if the station is in the authorized projects
         */
        if ($_REQUEST["station_id"] > 0) {
            $data = $dataClass->lire($_REQUEST["station_id"]);
            $project_id = $data["project_id"];
        } else {
            $project_id = $_REQUEST["project_id"];
        }
        if (!verifyProject($project_id)) {
            $module_coderetour = -1;
            $message->set(_("La station n'est pas associée à un projet pour lequel vous disposez des droits de modification"), true);
        } else {
            /**
             * write record in database
             */
            $id = dataWrite($dataClass, $_REQUEST);
            if ($id > 0) {
                $_REQUEST[$keyName] = $id;
            }
        }
        break;
    case "delete":
        /**
         * Verify if the station is in the authorized projects
         */
        if ($_REQUEST["station_id"] > 0) {
            $data = $dataClass->lire($_request["id"]);
            $project_id = $data["project_id"];
        } else {
            $project_id = $_REQUEST["project_id"];
        }
        if (!in_array($project_id, $_SESSION["projects"])) {
            $module_coderetour = -1;
            $message->set(_("La station n'est pas associée à un projet pour lequel vous disposez des droits de modification"), true);
        } else {
            /**
             * delete record
             */
            dataDelete($dataClass, $id);
        }
        break;
    case "getSensors":
        if (verifyProject($_REQUEST["project_id"])) {
            /**
             * Get the type of import
             */
            include_once "modules/classes/import/import_description.class.php";
            $id = new ImportDescription($bdd);
            $did = $id->lire($_REQUEST["import_description_id"]);
            $vue->set($dataClass->getListSensor($_REQUEST["project_id"], $did["import_type_id"]));
        }
        break;
}
