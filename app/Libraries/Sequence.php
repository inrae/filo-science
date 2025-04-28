<?php

namespace App\Libraries;

use App\Models\Ambience;
use App\Models\Analysis;
use App\Models\Individual;
use App\Models\IndividualTracking;
use App\Models\Sample;
use App\Models\Sequence as ModelsSequence;
use App\Models\SequenceGear;
use App\Models\SequencePoint;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Sequence extends PpciLibrary
{
    /**
     * @var ModelsSequence
     */
    protected PpciModel $dataclass;
    private int $campaign_id, $operation_id;
    private $activeTab;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsSequence;
        $this->keyName = "sequence_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_SESSION["ti_sequence"]->getValue($_REQUEST[$this->keyName]);
        }
        if (isset($_REQUEST["activeTab"])) {
            $this->activeTab = $_REQUEST["activeTab"];
        }
        $this->campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);
        $this->operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
    }


    function display()
    {
        if (empty($_REQUEST[$this->keyName])) {
            if ($_COOKIE["sequence_uid"] > 0 && $this->dataclass->isGranted($_SESSION["projects"], $_COOKIE["sequence_uid"])) {
                $this->id = $_COOKIE["sequence_uid"];
            } else {
                return defaultPage();
            }
        }
        $this->vue = service('Smarty');
        $data = $_SESSION["ti_campaign"]->translateRow(
            $_SESSION["ti_operation"]->translateRow(
                $_SESSION["ti_sequence"]->translateRow(
                    $this->dataclass->getDetail($this->id)
                )
            )
        );
        $this->vue->set($data, "data");
        $this->vue->set("gestion/sequenceDisplay.tpl", "corps");
        /**
         * related lists
         */
        $sg = new SequenceGear;
        $this->vue->set(
            $_SESSION["ti_sequenceGear"]->translateList(
                $_SESSION["ti_sequence"]->translateList(
                    $sg->getListFromSequence($this->id)
                )
            ),
            "gears"
        );
        $sample = new Sample;
        $this->vue->set(
            $_SESSION["ti_sample"]->translateList(
                $_SESSION["ti_sequence"]->translateList(
                    $sample->getListFromSequence($this->id)
                )
            ),
            "samples"
        );
        /**
         * Ambience
         */
        $ambience = new Ambience;
        $dataAmbience = $ambience->getFromSequence($this->id);
        if (!isset($dataAmbience["ambience_id"])) {
            $dataAmbience["ambience_id"] = 0;
            $dataAmbience["sequence_id"] = $this->id;
        }
        $dataAmbience = $_SESSION["ti_sequence"]->translateRow(
            $_SESSION["ti_ambience"]->translateRow(
                $dataAmbience
            )
        );
        if ($dataAmbience["ambience_id"] == "") {
            $dataAmbience["ambience_id"] = 0;
        }
        $this->vue->set($dataAmbience, "ambience");
        $other_measures = json_decode($dataAmbience["other_measures"], true);
        if (!empty($other_measures)) {
            $this->vue->set($other_measures, "other_measures");
        }

        /**
         * Analysis
         */
        $analysis = new Analysis;
        $dataAnalysis = $_SESSION["ti_sequence"]->translateRow(
            $_SESSION["ti_analysis"]->translateRow(
                $analysis->getListFromParent($this->id)[0]
            )
        );
        if (!isset($dataAnalysis["analysis_id"])) {
            $dataAnalysis["analysis_id"] = 0;
        }
        /*
         * Récupération des analyses complementaires dans un tableau pour l'affichage
         */
        $other_analysis = json_decode($dataAnalysis["other_analysis"], true);
        if (!empty($other_analysis)) {
            $this->vue->set($other_analysis, "other_analysis");
        }
        $this->vue->set(
            $dataAnalysis,
            "analysis"
        );
        /**
         * Points
         */
        $sequencePoint = new SequencePoint;
        $this->vue->set(
            $_SESSION["ti_sequencePoint"]->translateList(
                $_SESSION["ti_sequence"]->translateList(
                    $sequencePoint->getListFromSequence($this->id)
                )
            ),
            "points"
        );
        /**
         * select the good tab for display
         */
        if (isset($this->activeTab)) {
            $this->vue->set($this->activeTab, "activeTab");
        }
        /**
         * Map
         */
        setParamMap($this->vue);
        return $this->vue->send();
    }

    function change()
    {
        $this->vue = service('Smarty');
        $data = $this->dataRead($this->id, "gestion/sequenceChange.tpl", $this->operation_id);
        if ($data["sequence_id"] == 0) {
            /**
             * New sequence
             */
            $data["sequence_number"] = $this->dataclass->getLastSequenceNumber($this->operation_id);
        }
        $data["campaign_id"] = $this->campaign_id;
        $data = $_SESSION["ti_campaign"]->translateRow($data);
        $data = $_SESSION["ti_operation"]->translateRow($data);
        $this->vue->set($_SESSION["ti_sequence"]->translateRow($data), "data");
        /**
         * Preparation of the parameters tables
         */
        $params = array("water_regime", "fishing_strategy", "scale", "taxa_template", "protocol");
        foreach ($params as $tablename) {
            setParamToVue($this->vue, $tablename);
        }
        return $this->vue->send();
    }
    function write()
    {
        try {
            $data = $_SESSION["ti_campaign"]->getDbkeyFromRow($_REQUEST);
            $data = $_SESSION["ti_operation"]->getDbkeyFromRow($data);
            $data["sequence_id"] = $this->id;
            $this->id = $this->dataWrite($data);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $_SESSION["ti_sequence"]->setValue($this->id);
            }
            $this->activeTab = "tab-sequence";

            return true;
        } catch (PpciException $e) {
            return false;
        }

        /*
         * write record in database
         */
    }
    function delete()
    {
        /*
         * delete record
         */

        try {
            $this->dataDelete($this->id);
            $this->activeTab = "tab-sequence";
            return true;
        } catch (PpciException $e) {
            return false;
        };
    }
    function duplicate()
    {
        if ($this->id > 0) {
            /**
             * Get the record to duplicate
             */
            $data = $this->dataclass->lire($this->id);
            $data["sequence_number"] = $this->dataclass->getLastSequenceNumber($this->operation_id);
            $data["sequence_id"] = 0;
            $data["uuid"] = $this->dataclass->getUUID();
            $this->dataclass->autoFormatDate = false;
            unset($data["date_end"]);
            $data["date_start"] = date("Y-m-d H:i:s");
            $newid = $this->dataclass->ecrire($data);
            $this->dataclass->autoFormatDate = true;
            if ($newid > 0) {
                $data["sequence_id"] = $newid;
                /**
                 * Duplicate ambience
                 */
                $ambience = new Ambience;
                $dataAmbience = $ambience->getFromSequence($this->id);
                if ($dataAmbience["sequence_id"] > 0) {
                    $dataAmbience["ambience_id"] = 0;
                    $dataAmbience["sequence_id"] = $newid;
                    unset($dataAmbience["uuid"]);
                    $ambience->ecrire($dataAmbience);
                }
                /**
                 * Duplicate gears
                 */
                $sg = new SequenceGear;
                $gears = $sg->getListFromSequence($this->id);
                foreach ($gears as $gear) {
                    unset($gear["uuid"]);
                    $gear["sequence_id"] = $newid;
                    $gear["sequence_gear_id"] = 0;
                    $sg->ecrire($gear);
                }
                /**
                 * Set the new key for opening the new sequence
                 */
                $_COOKIE["sequence_uid"] = $newid;
                $_REQUEST["sequence_id"] = $_SESSION["ti_sequence"]->setValue($newid);
                return true;
            } else {
                $this->message->set(_("Une erreur est survenue pendant la duplication de la séquence"), true);
                return false;
            }
        } else {
            $this->message->set(_("Opération non permise"), true);
            return false;
        }
    }
    function addTelemetryFish()
    {
        $this->vue = service('Smarty');
        $data = $_SESSION["ti_campaign"]->translateRow(
            $_SESSION["ti_operation"]->translateRow(
                $_SESSION["ti_sequence"]->translateRow(
                    $this->dataclass->getDetail($this->id)
                )
            )
        );
        /**
         * Get the list of fish
         */
        $indiv = new IndividualTracking;
        $individuals = $indiv->getListNotInSequence($data["project_id"]);
        if (count($individuals) > 0) {
            $individuals = $_SESSION["ti_individual"]->translateList($individuals);
            $this->vue->set($data, "data");
            $this->vue->set("gestion/sequenceAddTelemetryFish.tpl", "corps");
            $this->vue->set($individuals, "individuals");
            return true;
        } else {
            $this->message->set(_("Il n'y a pas de poissons saisis dans le module de télémétrie qui ne soient pas associés avec une séquence"), true);
            return false;
        }
    }
    function addTelemetryFishExec()
    {
        if (count($_POST["uids"]) > 0) {
            /**
             * Extract the individual_id
             */
            $uids = array();
            foreach ($_POST["uids"] as $uid) {
                $uids[] = $_SESSION["ti_individual"]->getValue($uid);
            }
            /**
             * Get the list of fish ordered by scientific_name
             */
            $indiv = new IndividualTracking;
            $individuals = $indiv->getListFromUids($uids);
            /**
             * Prepare the list of samples
             */
            $samples = array();
            foreach ($individuals as $individual) {
                $taxonId = $individual["taxon_id"];
                $samples[$taxonId]["taxon_name"] = $individual["scientific_name"];
                $samples[$taxonId]["total_number"]++;
                $samples[$taxonId]["uids"][] = $individual["individual_id"];
            }
            /**
             * Write the samples and upgrade the individuals
             */
            try {
                $sampleClass = new Sample;
                $individualClass = new Individual;
                $db = $this->dataclass->db;
                $db->transBegin();
                foreach ($samples as $taxonId => $sample) {
                    $ds = array(
                        "sample_id" => 0,
                        "sequence_id" => $this->id,
                        "total_number" => $sample["total_number"],
                        "taxon_id" => $taxonId,
                        "taxon_name" => $sample["taxon_name"]
                    );
                    $sampleId = $sampleClass->ecrire($ds);
                    foreach ($sample["uids"] as $individual_id) {
                        $di = $individualClass->lire($individual_id);
                        $di["sample_id"] = $sampleId;
                        $individualClass->ecrire($di);
                    }
                }
                $db->transCommit();
                $this->message->set(_("Opération effectuée"));
                return true;
            } catch (PpciException $e) {
                $this->message->set(_("Une erreur est survenue pendant la mise à jour des informations"), true);
                $this->message->setSyslog($e->getMessage());
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                return false;
            }
        } else {
            $this->message->set(_("Aucun poisson sélectionné"), true);
            return false;
        }
    }
}
