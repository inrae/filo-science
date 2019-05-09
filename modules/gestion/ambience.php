<?php
require_once 'modules/classes/ambience.class.php';
$dataClass = new Ambience($bdd, $ObjetBDDParam);
$keyName = "ambience_id";
$id = $_SESSION["ti_ambience"]->getValue($_REQUEST[$keyName]);
$operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);

switch ($t_module["param"]) {
    case "change":
        $data = dataRead($dataClass, $id, "gestion/ambienceChange.tpl");
        if ($id == 0) {
            $data["operation_id"] = $operation_id;
            $data["sequence_id"] = $sequence_id;
        }
        $vue->set(
            $_SESSION["ti_ambience"]->translateRow(
                $_SESSION["ti_operation"]->translateRow(
                    $_SESSION["ti_sequence"]->translateRow(
                        $data
                    )
                )
            ),
            "data"
        );
        /**
         * Treatment of parameters
         */
        require_once 'modules/classes/param.class.php';
        $tables = array("granulometry", "speed", "shady", "clogging", "facies", "sinuosity", "localisation", "turbidity", "situation", "flow_trend", "vegetation", "cache_abundance");
        foreach ($tables as $tablename) {
            setParamToVue($vue, $tablename);
        }
        /**
         * Set origin
         */
        $vue->set($_REQUEST["origin"], "origin");
        /**
         * Get sequence or operation data
         */
        if ($_REQUEST["origin"] == "operation") {
            require_once 'modules/classes/operation.class.php';
            $op = new Operation($bdd, $ObjetBDDParam);
            $dparent = $_SESSION["ti_operation"]->translateRow(
                $_SESSION["ti_campaign"]->translateRow(
                    $op->getDetail($operation_id)
                )
            );
        } else {
            require_once 'modules/classes/sequence.class.php';
            $seq = new Sequence($bdd, $ObjetBDDParam);
            $dparent = $_SESSION["ti_operation"]->translateRow(
                $_SESSION["ti_campaign"]->translateRow(
                    $_SESSION["ti_sequence"]->translateRow(
                        $seq->getDetail($sequence_id)
                    )
                )
            );
        }
        $vue->set($dparent, "dataParent");
        break;
    case "write":
        /*
         * write record in database
         */
        $data = $_REQUEST;
        $data["ambience_id"] = $id;
        if ($operation_id > 0) {
            $data["operation_id"] = $operation_id;
        }
        if ($sequence_id > 0) {
            $data["sequence_id"] = $sequence_id;
        }
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
