<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $this->dataclass;
    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new XXX();
        $keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
require_once 'modules/classes/sample.class.php';
require_once 'modules/classes/individual.class.php';
if (!isset($ind)) {
    $ind = new Individual;
}
$this->dataclass = new Sample;
$keyName = "sample_id";
if (empty($_REQUEST[$keyName])&& !$_REQUEST[$keyName] ==0) {
    if (isset($_COOKIE["sample_uid"]) && $this->dataclass->isGranted($_SESSION["projects"], $_COOKIE["sample_uid"]) && $tmodule["param"] == "change") {
        $this->id = $_COOKIE["sample_uid"];
    } else {
        $t_module["param"] = "error";
        $t_module["retourko"] = "default";
        $module_coderetour = -1;
    }
} else {
    $this->id = $_SESSION["ti_sample"]->getValue($_REQUEST[$keyName]);
    $sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);
}


    function change()
{
$this->vue=service('Smarty');
        $data = $this->dataRead( $this->id, "gestion/sampleChange.tpl", $sequence_id);
        /**
         * set the real value of the key
         */
        $data["sample_uid"] = $data["sample_id"];
        if (!isset($sequence_id)) {
            $sequence_id = $data["sequence_id"];
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
        require_once 'modules/classes/sequence.class.php';
        $sequence = new Sequence;

        $ds = $_SESSION["ti_sequence"]->translateRow($sequence->getDetail($sequence_id));
        $ds = $_SESSION["ti_campaign"]->translateRow($ds);
        $ds = $_SESSION["ti_operation"]->translateRow($ds);
        $this->vue->set($ds, "sequence");
        /**
         * Generate the selection grid for taxa
         */
        if ($ds["taxa_template_id"] > 0) {
            include_once "modules/classes/taxaTemplate.class.php";
            $taxaTemplate = new TaxaTemplate;
            $dtt = $taxaTemplate->lire($ds["taxa_template_id"]);
            $grid = json_decode($dtt["taxa_model"], true);
            $newgrid = array();
            foreach ($grid as $element) {
                $name = "grid" . $element["row"] . "-" . $element["col"];
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
                    $ind->getListFromSample($this->id)
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
        $dataIndiv = $ind->lire($individual_id, true, $this->id);
        $this->vue->set(
            $_SESSION["ti_individual"]->translateRow(
                $_SESSION["ti_sample"]->translateRow(
                    $dataIndiv
                )
            ),
            "individual"
        );
        require_once 'modules/classes/sexe.class.php';
        $sexe = new Sexe;
        $this->vue->set($sexe->getListe(1), "sexes");
        require_once 'modules/classes/pathology.class.php';
        $pathology = new Pathology;
        $this->vue->set($pathology->getListe(3), "pathologys");
        /**
         * Get the list of transmitters for tracking
         */
        include_once 'modules/classes/tracking/transmitter_type.class.php';
        $tt = new TransmitterType;
        $this->vue->set($tt->getListe("transmitter_type_name"), "transmitters");
        /**
         * Get the list of release stations
         */
        require_once "modules/classes/tracking/station_tracking.class.php";
        $station = new StationTracking;
        $this->vue->set($station->getListFromProject($ds["project_id"], 3), "releaseStations");
        }
    function write()
{
try {
            $this->id =         try {
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST["xx_id"] = $this->id;
            return true;
        } catch (PpciException $e) {
            return false;
        }
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
        } catch (PpciException) {
            return false;
        }
        /*
         * write record in database
         */
        $data = $_POST;
        $data["sample_id"] = $this->id;
        $data["sequence_id"] = $sequence_id;
        try {
            $db = $this->dataclass->db;
$db->transBegin();
            if (!empty($data["sample_uuid"])) {
                $data["uuid"] = $data["sample_uuid"];
            }
            $this->id = dataWrite($this->dataclass, $data, true);
            if ($this->id > 0) {
                $_REQUEST[$keyName] = $_SESSION["ti_sample"]->setValue($this->id);
                /**
                 * Write individual, if necessary
                 */
                if ($_REQUEST["individualChange"]) {
                    $data["sample_id"] = $this->id;
                    $data["individual_id"] = $_SESSION["ti_individual"]->getValue($data["individual_id"]);
                    $data["uuid"] = $data["individual_uuid"];
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
            $this->dataclass->setCalculatedData($this->id);
            $db->transCommit();
            /**
             * Inactivate the modification if taxon_id_new is filled
             */
            if ($_POST["taxon_id_new"] > 0) {
                $_REQUEST["sample_id"] = 0;
            }
            $module_coderetour = -1;
        } catch (Exception $e) {
            if ($db->transEnabled) {
    $db->transRollback();
}
            $this->message->setSyslog($e->getMessage());
            $this->message->set(_("Problème lors de l'enregistrement de l'échantillon ou de l'individu"), true);
            $module_coderetour = -1;
        }
        $activeTab = "tab-sample";
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
        $activeTab = "tab-sample";
        }
    function deleteIndividual() {
        if ($_REQUEST["individual_id"] > 0) {
            $individual_id = $_SESSION["ti_individual"]->getValue($_REQUEST["individual_id"]);
            try {
                $db = $this->dataclass->db;
$db->transBegin();
                datadelete($ind, $individual_id, true);
                $this->dataclass->setCalculatedData($this->id);
                $db->transCommit();
                $this->message->set(_("Suppression effectuée"));
            } catch (Exception $e) {
                if ($db->transEnabled) {
    $db->transRollback();
}
                $this->message->set(_("Problème rencontré lors de la suppression du poisson"), true);
            }
        }
        }
}
