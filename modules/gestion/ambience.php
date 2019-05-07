<?php
require_once 'modules/classes/ambience.class.php';
$dataClass = new Ambience($bdd, $ObjetBDDParam);
$keyName = "ambience_id";
$id = $_SESSION["ti_ambience"]->getValue($_REQUEST[$keyName]);
$operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);

switch ($t_module["param"]) {



    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = dataRead($dataClass, $id, "gestion/ambienceChange.tpl", $campaign_id);
        $data = $_SESSION["ti_campaign"]->translateRow($data);
        $vue->set($_SESSION["ti_ambience"]->translateRow($data), "data");
        /**
         * Get campaign item
         */
        require_once 'modules/classes/campaign.class.php';
        $campaign = new Campaign($bdd, $ObjetBDDParam);
        $dcampaign = $campaign->lire($campaign_id);
        /**
         * Preparation of the parameters tables
         */
        $params = array("water_regime", "fishing_strategy", "scale", "taxa_template", "protocol");
        foreach ($params as $tablename) {
            setParamToVue($vue, $tablename);
        }
        /**
         * Stations
         */
        require_once 'modules/classes/station.class.php';
        $station = new Station($bdd, $ObjetBDDParam);
        $vue->set($station->getListFromProject($dcampaign["project_id"]),"stations");
        break;
    case "write":
        /*
         * write record in database
         */
        /**
         * Test if the project is authorized
         */
        $data = $_SESSION["ti_campaign"]->translateFromRow($_REQUEST);
        $data = $_SESSION["ti_ambience"]->translateFromRow($data);
        $id = dataWrite($dataClass, $data);
        if ($id > 0) {
            $_REQUEST[$keyName] = $_SESSION["ti_ambience"]->setValue($id);
        }

        break;
    case "delete":
        /*
         * delete record
         */

        dataDelete($dataClass, $id);

        break;
}