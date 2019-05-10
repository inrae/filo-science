<?php
require_once 'modules/classes/operation.class.php';
$dataClass = new Operation($bdd, $ObjetBDDParam);
$keyName = "operation_id";
$id = $_SESSION["ti_operation"]->getValue($_REQUEST[$keyName]);
$campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);
if (isset($_REQUEST["activeTab"])) {
    $activeTab = $_REQUEST["activeTab"];
}

switch ($t_module["param"]) {

    case "display":
        $data = $_SESSION["ti_operation"]->translateRow($dataClass->getDetail($id));
        $vue->set($_SESSION["ti_campaign"]->translateRow($data), "data");
        $vue->set("gestion/operationDisplay.tpl", "corps");
        /**
         * lists of related data
         */
        require_once 'modules/classes/sequence.class.php';
        $sequence = new Sequence($bdd, $ObjetBDDParam);
        $sequences = $sequence->getListFromParent($id);
        $sequences = $_SESSION["ti_sequence"]->translateList($sequences);
        $sequences = $_SESSION["ti_operation"]->translateList($sequences);
        $vue->set($sequences, "sequences");
        /**
         * Ambience
         */
        require_once 'modules/classes/ambience.class.php';
        $ambience = new Ambience($bdd, $ObjetBDDParam);
        $dataAmbience = $ambience->getFromOperation($id);
        if (!isset($dataAmbience["ambience_id"])) {
            $dataAmbience["ambience_id"] = 0;
            $dataAmbience["operation_id"] = $id;
        }
        $dataAmbience = $_SESSION["ti_operation"]->translateRow(
            $_SESSION["ti_ambience"]->translateRow(
                $dataAmbience
            )
        );
        if ($dataAmbience["ambience_id"] == "") {
            $dataAmbience["ambience_id"] = 0;
        }
        $vue->set($dataAmbience, "ambience");
        /**
         * select the good tab for display
         */
        if (isset($activeTab)) {
            $vue->set($activeTab, "activeTab");
        }
        /**
         * Map
         */
        setParamMap($vue);
        break;

    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = dataRead($dataClass, $id, "gestion/operationChange.tpl", $campaign_id);
        $data = $_SESSION["ti_campaign"]->translateRow($data);
        $vue->set($_SESSION["ti_operation"]->translateRow($data), "data");
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
        $vue->set($station->getListFromProject($dcampaign["project_id"]), "stations");
        /**
         * Map
         */
        setParamMap($vue);
        break;
    case "write":
        /*
         * write record in database
         */
        /**
         * Test if the project is authorized
         */
        $data = $_SESSION["ti_campaign"]->translateFromRow($_REQUEST);
        $data = $_SESSION["ti_operation"]->translateFromRow($data);
        $id = dataWrite($dataClass, $data);
        if ($id > 0) {
            $_REQUEST[$keyName] = $_SESSION["ti_operation"]->setValue($id);
        }

        break;
    case "delete":
        /*
         * delete record
         */

        dataDelete($dataClass, $id);

        break;
}
