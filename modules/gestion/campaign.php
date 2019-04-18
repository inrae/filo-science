<?php

require_once 'modules/classes/campaign.class.php';
$dataClass = new Campaign($bdd, $ObjetBDDParam);
$keyName = "campaign_id";
$id = $_SESSION["ti_campaign"]->getValue($_REQUEST[$keyName]);

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        try {
            /**
             * Search parameters
             */
            $_SESSION["searchCampaign"]->setParam($_REQUEST);
            $dataSearch = $_SESSION["searchCampaign"]->getParam();
            if ($_SESSION["searchCampaign"]->isSearch()) {
                $data = $dataClass->getListSearch($dataSearch);
                $vue->set($_SESSION["ti_campaign"]->translateList($data), "data");
                $vue->set(1, "isSearch");
            }

            $vue->set($_SESSION["projects"], "projects");
            $vue->set($dataSearch, "searchCampaign");
            $vue->set("gestion/campaignList.tpl", "corps");
        } catch (Exception $e) {
            $message->set($e->getMessage(), true);
        }
        break;
        case "display":
        $vue->set ($_SESSION["ti_campaign"]->translateRow($dataClass->getDetail($id)), "data");
        $vue->set ("gestion/campaignDisplay.tpl", "corps");
        /**
         * Get list of operations
         */


        break;

    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "param/campaignChange.tpl");
        break;
    case "write":
        /*
         * write record in database
         */
        /**
         * Test if the project is authorized
         */
        if (verifiyProject(_REQUEST["project_id"])) {
            $id = dataWrite($dataClass, $_REQUEST);
            if ($id > 0) {
                $_REQUEST[$keyName] = $id;
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
        if (verifiyProject(_REQUEST["project_id"])) {
            dataDelete($dataClass, $id);
        } else {
            $message->set(_("Vous ne disposez pas des droits nécessaires pour le projet considéré pour réaliser cette opération"), true);
            $module_coderetour = -1;
        }
        break;
}
