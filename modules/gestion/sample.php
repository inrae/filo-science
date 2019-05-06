<?php
require_once 'modules/classes/sample.class.php';
require_once 'modules/classes/individual.class.php';
$ind = new Individual($bdd, $ObjetBDDParam);
$dataClass = new Sample($bdd, $ObjetBDDParam);
$keyName = "sample_id";
$id = $_SESSION["ti_sample"]->getValue($_REQUEST[$keyName]);
$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);

switch ($t_module["param"]) {
    case "change":
        $data = dataRead($dataClass, $id, "gestion/sampleChange.tpl", $sample_id);
        $data = $_SESSION["ti_sample"]->translateRow($data);
        $data = $_SESSION["ti_sequence"]->translateRow($data);
        $vue->set($data, "data");
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

        $vue->set(
            $_SESSION["ti_individual"]->translateList(
                $_SESSION["ti_sample"]->translateList(
                    $ind->getListFromSample($id)
                )
            ),
            "individuals"
        );
        /**
         * Get an individual
         */
        if ($_REQUEST["individual_id"] > 0) {
            $individual_id = $_SESSION["ti_individual"]->getValue($_REQUEST["individual_id"]);
        } else {
            $individual_id = 0;
        }
        $dataIndiv = $ind->lire($individual_id, true, $id);
        $vue->set(
            $_SESSION["ti_individual"]->translateRow(
                $_SESSION["ti_sample"]->translateRow(
                    $dataIndiv
                )
            ),
            "individual"
        );
        require_once 'modules/classes/sexe.class.php';
        $sexe = new Sexe($bdd, $ObjetBDDParam);
        $vue->set($sexe->getListe(1), "sexes");
        require_once 'modules/classes/pathology.class.php';
        $pathology = new Pathology($bdd, $ObjetBDDParam);
        $vue->set($pathology->getListe(3), "pathologys");
        break;
    case "write":
        /*
         * write record in database
         */
        $data = $_POST;
        $data["sample_id"] = $id;
        $data["sequence_id"] = $sequence_id;
        try {
            $bdd->beginTransaction();
            $id = dataWrite($dataClass, $data, true);
            if ($id > 0) {
                $_REQUEST[$keyName] = $_SESSION["ti_sample"]->setValue($id);
                /**
                 * Write individual, if necessary
                 */
                if ($_REQUEST["individualChange"]) {
                    $data["sample_id"] = $id;
                    $data["individual_id"] = $_SESSION["ti_individual"]->getValue($data["individual_id"]);
                    $ind->ecrire($data);
                }
                /**
                 * Inhibition of display of the individu
                 */
                unset($_REQUEST["individual_id"]);
            }
            /**
             * Update sample from individuals
             */
            $dataClass->setCalculatedData($id);
            $bdd->commit();
            $module_coderetour = -1;
        } catch (Exception $e) {
            $bdd->rollback();
            $message->setSyslog($e->getMessage());
            $message->setLog(_("Problème lors de l'enregistrement de l'échantillon ou de l'individu"), true);
            $module_coderetour = -1;
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
    case "deleteIndividual":
        if ($_REQUEST["individual_id"] > 0) {
            $individual_id = $_SESSION["ti_individual"]->getValue($_REQUEST["individual_id"]);
            try {
                $bdd->beginTransaction();
                datadelete($ind, $individual_id, true);
                $dataClass->setCalculatedData($id);
                $bdd->commit();
                $message->set(_("Suppression effectuée"));
            } catch (Exception $e) {
                $bdd->rollback();
                $message->set(_("Problème rencontré lors de la suppression du poisson"), true);
            }
        }
        break;
}
