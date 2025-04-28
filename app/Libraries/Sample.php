<?php

namespace App\Libraries;

use App\Models\Individual;
use App\Models\Pathology;
use App\Models\Sample as ModelsSample;
use App\Models\Sequence;
use App\Models\Sexe;
use App\Models\StationTracking;
use App\Models\TaxaTemplate;
use App\Models\TransmitterType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Sample extends PpciLibrary
{
    /**
     * @var ModelsSample
     */
    protected PpciModel $dataclass;
    private int $sequence_id;
    protected Individual $individual;
    private $activeTab;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsSample;
        $this->keyName = "sample_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_SESSION["ti_sample"]->getValue($_REQUEST[$this->keyName]);
            $this->sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);
        }
        if (!isset($this->individual)) {
            $this->individual = new Individual;
        }
    }

    function change()
    {
        if (empty($_REQUEST[$this->keyName]) && !$_REQUEST[$this->keyName] == 0) {
            if (isset($_COOKIE["sample_uid"]) && $this->dataclass->isGranted($_SESSION["projects"], $_COOKIE["sample_uid"])) {
                $this->id = $_COOKIE["sample_uid"];
            } else {
                return defaultPage();
            }
        }
        $this->vue = service('Smarty');
        $data = $this->dataRead($this->id, "gestion/sampleChange.tpl", $this->sequence_id);
        /**
         * set the real value of the key
         */
        $data["sample_uid"] = $data["sample_id"];
        if (!isset($this->sequence_id)) {
            $this->sequence_id = $data["sequence_id"];
        }
        $data = $_SESSION["ti_sample"]->translateRow($data);
        $data = $_SESSION["ti_sequence"]->translateRow($data);
        if ($data["sample_uid"] == 0 && $_POST["taxon_id_new"] > 0) {
            $data["taxon_id"] = $_POST["taxon_id_new"];
            /**
             * Reinit individual
             */
            $_REQUEST["individual_id"] = 0;
        }
        $this->vue->set($data, "data");
        /**
         * Get the detail of the sequence
         */
        $sequence = new Sequence;

        $ds = $_SESSION["ti_sequence"]->translateRow($sequence->getDetail($this->sequence_id));
        $ds = $_SESSION["ti_campaign"]->translateRow($ds);
        $ds = $_SESSION["ti_operation"]->translateRow($ds);
        $this->vue->set($ds, "sequence");
        /**
         * Generate the selection grid for taxa
         */
        if ($ds["taxa_template_id"] > 0) {
            $taxaTemplate = new TaxaTemplate;
            $dtt = $taxaTemplate->lire($ds["taxa_template_id"]);
            $grid = json_decode($dtt["taxa_model"], true);
            $newgrid = array();
            foreach ($grid as $element) {
                //$name = "grid" . $element["row"] . "-" . $element["col"];
                $newgrid[$element["row"]][$element["col"]] = $element["val"];
            }
            $this->vue->set($newgrid, "grid");
        }
        /**
         * Get the list of individuals
         */

        $this->vue->set(
            $_SESSION["ti_individual"]->translateList(
                $_SESSION["ti_sample"]->translateList(
                    $this->individual->getListFromSample($this->id)
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
        $dataIndiv = $this->individual->lire($individual_id, true, $this->id);
        $this->vue->set(
            $_SESSION["ti_individual"]->translateRow(
                $_SESSION["ti_sample"]->translateRow(
                    $dataIndiv
                )
            ),
            "individual"
        );
        $sexe = new Sexe;
        $this->vue->set($sexe->getListe(1), "sexes");
        $pathology = new Pathology;
        $this->vue->set($pathology->getListe(3), "pathologys");
        /**
         * Get the list of transmitters for tracking
         */
        $tt = new TransmitterType;
        $this->vue->set($tt->getListe("transmitter_type_name"), "transmitters");
        /**
         * Get the list of release stations
         */
        $station = new StationTracking;
        $this->vue->set($station->getListFromProject($ds["project_id"], 3), "releaseStations");
        $this->vue->set($this->activeTab, "activeTab");
        return $this->vue->send();
    }
    function write()
    {


        /*
         * write record in database
         */
        $data = $_POST;
        $data["sample_id"] = $this->id;
        $data["sequence_id"] = $this->sequence_id;
        try {
            $db = $this->dataclass->db;
            $db->transBegin();
            if (!empty($data["sample_uuid"])) {
                $data["uuid"] = $data["sample_uuid"];
            }
            $this->id = $this->dataWrite($data, true);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $_SESSION["ti_sample"]->setValue($this->id);
                /**
                 * Write individual, if necessary
                 */
                if ($_REQUEST["individualChange"]) {
                    $data["sample_id"] = $this->id;
                    $data["individual_id"] = $_SESSION["ti_individual"]->getValue($data["individual_id"]);
                    $data["uuid"] = $data["individual_uuid"];
                    $this->individual->ecrire($data);
                }
                /**
                 * Inhibition of display of the individu
                 */
                unset($_REQUEST["individual_id"]);
            }
            /**
             * Update sample from individuals
             */
            $this->dataclass->setCalculatedData($this->id);
            $db->transCommit();
            /**
             * Inactivate the modification if taxon_id_new is filled
             */
            if ($_POST["taxon_id_new"] > 0) {
                $_REQUEST["sample_id"] = 0;
            }
            return false;
        } catch (PpciException $e) {
            if ($db->transEnabled) {
                $db->transRollback();
            }
            $this->message->setSyslog($e->getMessage());
            $this->message->set(_("Problème lors de l'enregistrement de l'échantillon ou de l'individu"), true);
            return false;
        }
        $this->activeTab = "tab-sample";
    }
    function delete()
    {
        /*
         * delete record
         */

        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        };
        $this->activeTab = "tab-sample";
    }
    function deleteIndividual()
    {
        if ($_REQUEST["individual_id"] > 0) {
            $individual_id = $_SESSION["ti_individual"]->getValue($_REQUEST["individual_id"]);
            try {
                $db = $this->dataclass->db;
                $db->transBegin();
                $this->datadelete($this->individual, $individual_id, true);
                $this->dataclass->setCalculatedData($this->id);
                $db->transCommit();
                $this->message->set(_("Suppression effectuée"));
                return true;
            } catch (PpciException $e) {
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                $this->message->set(_("Problème rencontré lors de la suppression du poisson"), true);
                return false;
            }
        }
    }
}
