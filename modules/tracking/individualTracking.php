<?php
include_once 'modules/classes/individual_tracking.class.php';
$dataClass = new IndividualTracking($bdd, $ObjetBDDParam);
$keyName = "individual_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        include_once 'modules/classes/project.class.php';
        $project = new Project($bdd, $ObjetBDDParam);
        isset($_COOKIE["projectId"]) ? $project_id = $_COOKIE["projectId"] : $project_id = 0;
        isset($_COOKIE["projectActive"]) ? $is_active = $_COOKIE["projectActive"] : $is_active = 1;
        $vue->set($projects = $project->getProjectsActive($is_active, $_SESSION["projects"]), "projects");
        if ($project_id > 0 && !verifiyProject($project_id)) {
            $project_id = $projects[0]["project_id"];
        }
        if (! $project_id > 0) {
            $project_id = $projects[0]["project_id"];
        }
        $vue->set($dataClass->getListFromProject($project_id), "individuals");
        $vue->set("tracking/individualTrackingList.tpl", "corps");
        break;
    }