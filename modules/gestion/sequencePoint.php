<?php
require_once 'modules/classes/sequence_point.class.php';
$dataClass = new SequencePoint($bdd, $ObjetBDDParam);
$keyName = "sequence_point_id";
if (empty($_REQUEST[$keyName]){
    $t_module["param"] = "error";
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
}
$id = $_SESSION["ti_sequencePoint"]->getValue($_REQUEST[$keyName]);
$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);
if (empty($id) ) {
    $t_module["param"] = "error";
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
}
switch ($t_module["param"]) {
    case "change":
        $vue->set("gestion/sequencePointChange.tpl", "corps");
        $data = $dataClass->lire($id, true, $sequence_id);
        $data["sequence_id"] = $_SESSION["ti_sequence"]->setValue($sequence_id);
        $vue->set($data = $_SESSION["ti_sequencePoint"]->translateRow($data), "data");
        require_once 'modules/classes/sequence.class.php';
        $sequence = new Sequence($bdd, $ObjetBDDParam);
        $dsequence = $sequence->getDetail($sequence_id);
        $dsequence = $_SESSION["ti_sequence"]->translateRow($dsequence);
        $dsequence = $_SESSION["ti_operation"]->translateRow($dsequence);
        $dsequence = $_SESSION["ti_campaign"]->translateRow($dsequence);
        $vue->set($dsequence, "sequence");
        /**
         * Preparation of the parameters tables
         */
        $params = array("localisation", "facies");
        foreach ($params as $tablename) {
            setParamToVue($vue, $tablename);
        }
        break;
    case "write":
        /*
         * write record in database
         */
        $data = $_SESSION["ti_sequence"]->getDbkeyFromRow($_REQUEST);
        $data = $_SESSION["ti_sequencePoint"]->getDbkeyFromRow($data);
        $data["sequence_point_id"] = $id;
        dataWrite($dataClass, $data);
        /**
         * Treatment of a new record
         */
        if ($module_coderetour == 1) {
            $_REQUEST[$keyName] = 0;
        }
        $activeTab = "tab-point";
        break;
    case "delete":
        /*
         * delete record
         */

        dataDelete($dataClass, $id);
        $activeTab = "tab-point";
        break;
}
