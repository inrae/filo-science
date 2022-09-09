<?php
require_once 'modules/classes/operation.class.php';
$dataClass = new Operation($bdd, $ObjetBDDParam);
$keyName = "operation_id";
if (empty($_REQUEST[$keyName]) && !$_REQUEST[$keyName] == 0 ){
    if ($_COOKIE["operation_uid"] > 0 && $dataClass->isGranted($_SESSION["projects"], $_COOKIE["operation_uid"]) && $t_module["param"] == "display") {
        $id = $_COOKIE["operation_uid"];
    } else {
        $t_module["param"] = "error";
        $t_module["retourko"] = "default";
        $module_coderetour = -1;
        $message->set(_("L'identifiant de l'opération est manquant"), true);
    }
} else {
    $origine == "document" ? $id = $_REQUEST[$keyName] : $id = $_SESSION["ti_operation"]->getValue($_REQUEST[$keyName]);
}

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
        $sequences = $sequence->getListFromOperation($id);
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
         * Operators
         */
        require_once 'modules/classes/operator.class.php';
        $operator = new Operator($bdd, $ObjetBDDParam);
        $vue->set($operator->getListFromOperation($id), "operators");
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
        /**
         * Documents
         */
        include_once 'modules/classes/document.class.php';
        $document = new Document($bdd, $ObjetBDDParam);
        $vue->set($document->documentGetListFromParent("operation", $id), "dataDoc");
        $vue->set("operation", "moduleParent");
        $vue->set($id, "parent_id");
        break;

    case "change":
        /**
         * Get campaign item
         */
        require_once 'modules/classes/campaign.class.php';
        $campaign = new Campaign($bdd, $ObjetBDDParam);
        $dcampaign = $campaign->getDetail($campaign_id);
        $data = dataRead($dataClass, $id, "gestion/operationChange.tpl", $campaign_id);
        if ($data["operation_id"] == 0) {
            $data["protocol_id"] = $dcampaign["protocol_default_id"];
        }
        $data = $_SESSION["ti_campaign"]->translateRow($data);
        $vue->set($_SESSION["ti_operation"]->translateRow($data), "data");
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
        $data = $_SESSION["ti_campaign"]->getDbkeyFromRow($_REQUEST);
        $data = $_SESSION["ti_operation"]->getDbkeyFromRow($data);
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
    case "operatorsChange":
        /**
         * Add operators to the operation
         */
        require_once 'modules/classes/operator.class.php';
        $operator = new Operator($bdd, $ObjetBDDParam);
        try {
            $bdd->beginTransaction();
            $operator->setOperatorsToOperation($id, $_POST["operators"], $_POST["operator_responsible"]);
            $module_coderetour = 1;
            $bdd->commit();
        } catch (ObjetBDDException $e) {
            $bdd->rollback();
            $message->set(_("Problème rencontré lors de l'enregistrement des opérateurs"), true);
            $message->setSyslog($e->getMessage());
            $module_coderetour = -1;
        }
        break;
        case "duplicate":
        try {
            $bdd->beginTransaction();
            $newid = $dataClass->duplicate($id);
            if ($newid > 0) {
                $_REQUEST[$keyName] = $_SESSION["ti_operation"]->setValue($newid);
            }
            $module_coderetour = 1;
            $bdd->commit();
        } catch (ObjetBDDException $e) {
            $bdd->rollback();
            $message->set(_("Problème rencontré lors de la duplication de l'opération"), true);
            $message->setSyslog($e->getMessage());
            $module_coderetour = -1;
        }
}
