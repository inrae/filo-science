<?php
require_once 'modules/classes/sequence_gear.class.php';
$dataClass = new SequenceGear($bdd, $ObjetBDDParam);
$keyName = "sequence_gear_id";
$id = $_SESSION["ti_sequenceGear"]->getValue($_REQUEST[$keyName]);
$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);
switch ($t_module["param"]) {

    
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = dataRead($dataClass, $id, "gestion/sequenceGearChange.tpl", $sequence_id);

        $data["sequence_id"] = $_SESSION["ti_sequence"]->setValue($sequence_id);
        $vue->set($data = $_SESSION["ti_sequenceGear"]->translateRow($data), "data");
        /**
         * Preparation of the parameters tables
         */
        $params = array("electric_current_type", "gear_method", "gear");
        foreach ($params as $tablename) {
            setParamToVue($vue, $tablename);
        }
        break;
    case "write":
        /*
         * write record in database
         */
        $data = $_SESSION["ti_sequence"]->translateFromRow($_REQUEST);
        $data = $_SESSION["ti_sequenceGear"]->translateFromRow($data);
        $data["sequence_gear_id"] = $id;
        $id = dataWrite($dataClass, $data);
        if ($id > 0) {
            $_REQUEST[$keyName] = $_SESSION["ti_sequenceGear"]->setValue($id);
        }
        $activeTab = "tab-gear";
        break;
    case "delete":
        /*
         * delete record
         */

        dataDelete($dataClass, $id);
        $activeTab = "tab-gear";

        break;
}
