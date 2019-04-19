<?php
require_once 'modules/classes/operation.class.php';
$dataClass = new Operation($bdd, $ObjetBDDParam);
$keyName = "operation_id";
$id = $_SESSION["ti_operation"]->getValue($_REQUEST[$keyName]);
$campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);

switch ($t_module["param"]) {

    case "display":
    $data = $_SESSION["ti_operation"]->translateRow($dataClass->getDetail($id));
        $vue->set($_SESSION["ti_campaign"]->translateRow($data), "data");
        $vue->set("gestion/operationDisplay.tpl", "corps");

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
         * Preparation of the parameters tables
         */
        $params = array ("water_regime", "fishing_strategy", "scale", "taxa_template", "protocol");
        foreach ($params as $tablename) {
            setParamToVue($vue, $tablename);
        }
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
