<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class  extends PpciLibrary { 
    /**
     * @var Models
*/
    protected PpciModel $dataclass;
    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ;
        $this->keyName = "";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
require_once 'modules/classes/sequence.class.php';
$this->dataclass = new Sequence;
$this->keyName = "sequence_id";
if (empty($_REQUEST[$this->keyName]) && $t_module["param"] == "display") {
  if ($_COOKIE["sequence_uid"] > 0 && $this->dataclass->isGranted($_SESSION["projects"], $_COOKIE["sequence_uid"]) && $t_module["param"] == "display") {
    $this->id = $_COOKIE["sequence_uid"];
  } else {
    $t_module["param"] = "error";
    $t_module["retourko"] = "default";
    return false;
  }
} else {
  $this->id = $_SESSION["ti_sequence"]->getValue($_REQUEST[$this->keyName]);
}
$campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);
$operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
if (isset($_REQUEST["activeTab"])) {
  $activeTab = $_REQUEST["activeTab"];
}



  function display()
{
$this->vue=service('Smarty');
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
    require_once 'modules/classes/sequence_gear.class.php';
    $sg = new SequenceGear;
    $this->vue->set(
      $_SESSION["ti_sequenceGear"]->translateList(
        $_SESSION["ti_sequence"]->translateList(
          $sg->getListFromSequence($this->id)
        )
      ),
      "gears"
    );
    require_once 'modules/classes/sample.class.php';
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
    require_once 'modules/classes/ambience.class.php';
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
    require_once 'modules/classes/analysis.class.php';
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
    require_once "modules/classes/sequence_point.class.php";
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
    if (isset($activeTab)) {
      $this->vue->set($activeTab, "activeTab");
    }
    /**
     * Map
     */
    setParamMap($this->vue);
    }

  function change()
{
$this->vue=service('Smarty');
    /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
    $data = $this->dataRead( $this->id, "gestion/sequenceChange.tpl", $operation_id);
    if ($data["sequence_id"] == 0) {
      /**
       * New sequence
       */
      $data["sequence_number"] = $this->dataclass->getLastSequenceNumber($operation_id);
    }
    $data["campaign_id"] = $campaign_id;
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
    }
  function write()
{
try {
            
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST[$this->keyName] = $this->id;
            return true;
        } catch (PpciException $e) {
            return false;
        }
           
    /*
         * write record in database
         */
    $data = $_SESSION["ti_campaign"]->getDbkeyFromRow($_REQUEST);
    $data = $_SESSION["ti_operation"]->getDbkeyFromRow($data);
    $data["sequence_id"] = $this->id;
    $this->id = $this->dataWrite($this->dataclass, $data);
    if ($this->id > 0) {
      $_REQUEST[$this->keyName] = $_SESSION["ti_sequence"]->setValue($this->id);
    }
    $activeTab = "tab-sequence";
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
    $activeTab = "tab-sequence";
    }
  function duplicate() {
    if ($this->id > 0) {
      /**
       * Get the record to duplicate
       */
      $data = $this->dataclass->lire($this->id);
      $data["sequence_number"] = $this->dataclass->getLastSequenceNumber($operation_id);
      $data["sequence_id"] = 0;
      $data["uuid"] = $this->dataclass->getUUID();
      $this->dataclass->auto_date = 0;
      unset($data["date_end"]);
      $data["date_start"] = date("Y-m-d H:i:s");
      $newid = $this->dataclass->ecrire($data);
      $this->dataclass->auto_date = 1;
      if ($newid > 0) {
        $data["sequence_id"] = $newid;
        /**
         * Duplicate ambience
         */
        include_once "modules/classes/ambience.class.php";
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
        require_once "modules/classes/sequence_gear.class.php";
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
        $_REQUEST["sequence_id"] = $_SESSION["ti_sequence"]->setValue($newid);;
        return true;
      } else {
        $this->message->set(_("Une erreur est survenue pendant la duplication de la séquence"), true);
        return false;
      }
    } else {
      return false;
      $this->message->set(_("Opération non permise"), true);
    }
    }
  function addTelemetryFish() {
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
    include_once "modules/classes/tracking/individual_tracking.class.php";
    $indiv = new IndividualTracking;
    $individuals = $indiv->getListNotInSequence($data["project_id"]);
    if (count($individuals) > 0) {
      $individuals = $_SESSION["ti_individual"]->translateList($individuals);
      $this->vue->set($data, "data");
      $this->vue->set("gestion/sequenceAddTelemetryFish.tpl", "corps");
      $this->vue->set($individuals, "individuals");
      return true;
    } else {
      return false;
      $this->message->set(_("Il n'y a pas de poissons saisis dans le module de télémétrie qui ne soient pas associés avec une séquence"), true);
    }
    }
  function addTelemetryFishExec() {
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
      include_once "modules/classes/tracking/individual_tracking.class.php";
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
        include_once "modules/classes/sample.class.php";
        include_once "modules/classes/individual.class.php";
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
      } catch (Exception $e) {
        $this->message->set(_("Une erreur est survenue pendant la mise à jour des informations"), true);
        $this->message->setSyslog($e->getMessage());
        if ($db->transEnabled) {
    $db->transRollback();
}
        return false;
      }
    } else {
      return false;
      $this->message->set(_("Aucun poisson sélectionné"), true);
    }
    }
}
