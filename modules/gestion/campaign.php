<?php
require_once 'modules/classes/campaign.class.php';
$dataClass = new Campaign($bdd, $ObjetBDDParam);
$keyName = "campaign_id";
if (empty($_REQUEST[$keyName])&& $t_module["param"] == "display") {
    if ($_COOKIE["campaign_uid"] > 0 && $dataClass->isGranted($_SESSION["projects"], $_COOKIE["campaign_uid"]) ) {
        $id = $_COOKIE["campaign_uid"];
    } else {
        $t_module["param"] = "error";
        $t_module["retourko"] = "default";
        $module_coderetour = -1;
    }
} else {
    $id = $_SESSION["ti_campaign"]->getValue($_REQUEST[$keyName]);
}


switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        try {
            /**
             * Search parameters
             */
            $params = $_REQUEST;
            if (!isset($params["is_active"])) {
                $params["is_active"] = 1;
            }
            include_once "modules/classes/project.class.php";
            $project = new Project($bdd, $ObjetBDDParam);
            $projects = $project->getProjectsActive($params["is_active"], $_SESSION["projects"]);
            if (empty($params["project_id"]) ) {
                $params["project_id"] = $projects[0]["project_id"];
            }
            $_SESSION["searchCampaign"]->setParam($params);
            $dataSearch = $_SESSION["searchCampaign"]->getParam();

            $data = $dataClass->getListSearch($dataSearch);
            $vue->set($_SESSION["ti_campaign"]->translateList($data), "data");
            $vue->set(1, "isSearch");


            $vue->set($projects, "projects");
            $vue->set($dataSearch, "searchCampaign");
            $vue->set("gestion/campaignList.tpl", "corps");
        } catch (Exception $e) {
            $message->set($e->getMessage(), true);
        }
        break;
    case "display":
        $vue->set($_SESSION["ti_campaign"]->translateRow($dataClass->getDetail($id)), "data");
        $vue->set("gestion/campaignDisplay.tpl", "corps");
        /**
         * Get list of operations
         */
        require_once 'modules/classes/operation.class.php';
        $operation = new Operation($bdd, $ObjetBDDParam);
        $doperation = $_SESSION["ti_operation"]->translateList($operation->getListFromCampaign($id));
        $vue->set($_SESSION["ti_campaign"]->translateList($doperation), "operations");

        break;

    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = dataRead($dataClass, $id, "gestion/campaignChange.tpl");
        $vue->set($_SESSION["ti_campaign"]->translateRow($data), "data");
        $vue->set($_SESSION["projects"], "projects");
        break;
    case "write":
        /*
         * write record in database
         */
        /**
         * Test if the project is authorized
         */
        if (verifyProject($_REQUEST["project_id"])) {
            $id = dataWrite($dataClass, $_SESSION["ti_campaign"]->getDbkeyFromRow($_REQUEST));
            if ($id > 0) {
                $_REQUEST[$keyName] = $_SESSION["ti_campaign"]->setValue($id);
            }
        } else {
            $message->set(_("Vous ne disposez pas des droits nécessaires pour le projet considéré pour réaliser cette opération"), true);
            $module_coderetour = -1;
        }
        break;
    case "delete":
        /*
         * delete record
         */
        if (verifyProject($_REQUEST["project_id"])) {
            dataDelete($dataClass, $id);
        } else {
            $message->set(_("Vous ne disposez pas des droits nécessaires pour le projet considéré pour réaliser cette opération"), true);
            $module_coderetour = -1;
        }
        break;
}
