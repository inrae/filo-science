<?php
require_once 'modules/classes/sample.class.php';

$dataClass = new Sample($bdd, $ObjetBDDParam);
$keyName = "sample_id";
$id = $_SESSION["ti_sample"]->getValue($_REQUEST[$keyName]);
$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);

switch ($t_module["param"]) {
    case "change":
        $data = dataRead($dataClass, $id, "gestion/sampleChange.tpl", $sample_id);
        $data = $_SESSION["ti_sample"]->translateRow($data);
        $data = $_SESSION["ti_sample"]->translateRow($data);
        /**
         * Get the detail of the sequence
         */
        require_once 'modules/classes/sequence.class.php';
        $sequence = new Sequence($bdd, $ObjetBDDParam);
        $ds = $_SESSION["ti_sequence"]->translateRow($sequence->getDetail($sequence_id));
        $ds = $_SESSION["ti_campaign"]->translateRow($ds);
        $ds = $_SESSION["ti_operation"]->translateRow($ds);
        $vue->set($ds, "sequence");
        /**
         * Get the list of individuals
         */
        require_once 'modules/classes/individual.class.php';
        $ind = new Individual($bdd, $ObjetBDDParam);
        $vue->set(
            $_SESSION["ti_individual"]->translateRow(
                $_SESSION["ti_sample"]->translateRow(
                    $ind->getListFromSample($id)
                )
            ),
            "individuals"
        );
        /**
         * Get an individual, if necessary, for change
         */
        if ($id > 0) {
            if ($_REQUEST["individual_id"] > 0) {
                $individual_id = $_SESSION["ti_individual"]->getValue($_REQUEST["individual_id"]);
            } else {
                $individual_id = 0;
            }
            $dataIndiv = $ind->lire($individual_id, true, $id);
            $vue->set(
                $_SESSION["ti_individual"]->translateFromRow(
                    $_SESSION["ti_sample"]->translateFromRow(
                        $dataIndiv
                    ),
                    "individual"
                )
            );
        }
        break;
    case "write":
        /*
         * write record in database
         */
        $data = $_POST;
        $data["sample_id"] = $id;
        $data["sequence_id"] = $sequence_id;
        $id = dataWrite($dataClass, $data);
        if ($id > 0) {
            $_REQUEST[$keyName] = $_SESSION["ti_sample"]->setValue($id);
        }
        $activeTab = "tab-sample";
        break;
    case "delete":
        /*
         * delete record
         */

        dataDelete($dataClass, $id);
        $activeTab = "tab-sample";
        break;
}
