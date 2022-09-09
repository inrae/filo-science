<?php
require_once 'modules/classes/analysis.class.php';
$dataClass = new Analysis($bdd, $ObjetBDDParam);
$keyName = "analysis_id";
if (empty($_REQUEST[$keyName]))) {
    $t_module["param"] = "error";
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
}
$id = $_SESSION["ti_analysis"]->getValue($_REQUEST[$keyName]);
if (empty($id) ) {
    $id = 0;
}

$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);

switch ($t_module["param"]) {
    case "change":
        /*
     * open the form to modify the record
     * If is a new record, generate a new record with default value :
     * $_REQUEST["idParent"] contains the identifiant of the parent record
     */
        $data = dataRead($dataClass, $id, "gestion/analysisChange.tpl", $sequence_id);
        require_once "modules/classes/sequence.class.php";
        $sequence = new Sequence($bdd, $ObjetBDDParam);
        $dataSequence = $_SESSION["ti_operation"]->translateRow(
            $_SESSION["ti_campaign"]->translateRow(
                $_SESSION["ti_sequence"]->translateRow(
                    $sequence->getDetail($sequence_id)
                )
            )
        );
        $vue->set(
            $dataSequence,
            "sequence"
        );
        if ($dataSequence["analysis_template_id"] > 0) {
            /**
             * Get the complementary analysis template
             */
            include_once "modules/classes/analysis_template.class.php";
            $at = new AnalysisTemplate($bdd, $ObjetBDDParam);
            $dat = $at->lire($dataSequence["analysis_template_id"]);
            $vue->set($dat["analysis_template_schema"], "analysis_template_schema");
        }
        if ($data["analysis_id"] == 0) {
            /**
             * Create a new record
             */
            $data["analysis_date"] = $dataSequence["date_start"];
            $data["sequence_id"] = $sequence_id;
        }
        $vue->set(
            $_SESSION["ti_sequence"]->translateRow(
                $_SESSION["ti_analysis"]->translateRow(
                    $data
                )
            ),
            "data"
        );
        break;
    case "write":
        /**
         * write record in database
         */
        $data = $_REQUEST;
        $data["sequence_id"] = $sequence_id;
        $data ["analysis_id"] = $id;
        $id = dataWrite($dataClass, $data);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        /*
     * delete record
     */
        dataDelete($dataClass, $id);
        break;
}
