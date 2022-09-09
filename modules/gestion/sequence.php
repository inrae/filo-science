<?php
require_once 'modules/classes/sequence.class.php';
$dataClass = new Sequence($bdd, $ObjetBDDParam);
$keyName = "sequence_id";
if (empty($_REQUEST[$keyName]){
  if ($_COOKIE["sequence_uid"] > 0 && $dataClass->isGranted($_SESSION["projects"], $_COOKIE["sequence_uid"]) && $t_module["param"] == "display") {
    $id = $_COOKIE["sequence_uid"];
  } else {
    $t_module["param"] = "error";
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
  }
} else {
  $id = $_SESSION["ti_sequence"]->getValue($_REQUEST[$keyName]);
}
$campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);
$operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
if (isset($_REQUEST["activeTab"])) {
  $activeTab = $_REQUEST["activeTab"];
}

switch ($t_module["param"]) {

  case "display":
    $data = $_SESSION["ti_campaign"]->translateRow(
      $_SESSION["ti_operation"]->translateRow(
        $_SESSION["ti_sequence"]->translateRow(
          $dataClass->getDetail($id)
        )
      )
    );
    $vue->set($data, "data");
    $vue->set("gestion/sequenceDisplay.tpl", "corps");
    /**
     * related lists
     */
    require_once 'modules/classes/sequence_gear.class.php';
    $sg = new SequenceGear($bdd, $ObjetBDDParam);
    $vue->set(
      $_SESSION["ti_sequenceGear"]->translateList(
        $_SESSION["ti_sequence"]->translateList(
          $sg->getListFromSequence($id)
        )
      ),
      "gears"
    );
    require_once 'modules/classes/sample.class.php';
    $sample = new Sample($bdd, $ObjetBDDParam);
    $vue->set(
      $_SESSION["ti_sample"]->translateList(
        $_SESSION["ti_sequence"]->translateList(
          $sample->getListFromSequence($id)
        )
      ),
      "samples"
    );
    /**
     * Ambience
     */
    require_once 'modules/classes/ambience.class.php';
    $ambience = new Ambience($bdd, $ObjetBDDParam);
    $dataAmbience = $ambience->getFromSequence($id);
    if (!isset($dataAmbience["ambience_id"])) {
      $dataAmbience["ambience_id"] = 0;
      $dataAmbience["sequence_id"] = $id;
    }
    $dataAmbience = $_SESSION["ti_sequence"]->translateRow(
      $_SESSION["ti_ambience"]->translateRow(
        $dataAmbience
      )
    );
    if ($dataAmbience["ambience_id"] == "") {
      $dataAmbience["ambience_id"] = 0;
    }
    $vue->set($dataAmbience, "ambience");
    $other_measures = json_decode($dataAmbience["other_measures"], true);
    if (count($other_measures) > 0) {
      $vue->set($other_measures, "other_measures");
    }

    /**
     * Analysis
     */
    require_once 'modules/classes/analysis.class.php';
    $analysis = new Analysis($bdd, $ObjetBDDParam);
    $dataAnalysis = $_SESSION["ti_sequence"]->translateRow(
      $_SESSION["ti_analysis"]->translateRow(
        $analysis->getListFromParent($id)[0]
      )
    );
    if (!isset($dataAnalysis["analysis_id"])) {
      $dataAnalysis["analysis_id"] = 0;
    }
    /*
         * Récupération des analyses complementaires dans un tableau pour l'affichage
         */
    $other_analysis = json_decode($dataAnalysis["other_analysis"], true);
    if (count($other_analysis) > 0) {
      $vue->set($other_analysis, "other_analysis");
    }
    $vue->set(
      $dataAnalysis,
      "analysis"
    );
    /**
     * Points
     */
    require_once "modules/classes/sequence_point.class.php";
    $sequencePoint = new SequencePoint($bdd, $ObjetBDDParam);
    $vue->set(
      $_SESSION["ti_sequencePoint"]->translateList(
        $_SESSION["ti_sequence"]->translateList(
          $sequencePoint->getListFromSequence($id)
        )
      ),
      "points"
    );
    /**
     * select the good tab for display
     */
    if (isset($activeTab)) {
      $vue->set($activeTab, "activeTab");
    }
    /**
     * Map
     */
    setParamMap($vue);
    break;

  case "change":
    /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
    $data = dataRead($dataClass, $id, "gestion/sequenceChange.tpl", $operation_id);
    if ($data["sequence_id"] == 0) {
      /**
       * New sequence
       */
      $data["sequence_number"] = $dataClass->getLastSequenceNumber($operation_id);
    }
    $data["campaign_id"] = $campaign_id;
    $data = $_SESSION["ti_campaign"]->translateRow($data);
    $data = $_SESSION["ti_operation"]->translateRow($data);
    $vue->set($_SESSION["ti_sequence"]->translateRow($data), "data");
    /**
     * Preparation of the parameters tables
     */
    $params = array("water_regime", "fishing_strategy", "scale", "taxa_template", "protocol");
    foreach ($params as $tablename) {
      setParamToVue($vue, $tablename);
    }
    break;
  case "write":
    /*
         * write record in database
         */
    $data = $_SESSION["ti_campaign"]->getDbkeyFromRow($_REQUEST);
    $data = $_SESSION["ti_operation"]->getDbkeyFromRow($data);
    $data["sequence_id"] = $id;
    $id = dataWrite($dataClass, $data);
    if ($id > 0) {
      $_REQUEST[$keyName] = $_SESSION["ti_sequence"]->setValue($id);
    }
    $activeTab = "tab-sequence";
    break;
  case "delete":
    /*
         * delete record
         */

    dataDelete($dataClass, $id);
    $activeTab = "tab-sequence";
    break;
  case "duplicate":
    if ($id > 0) {
      /**
       * Get the record to duplicate
       */
      $data = $dataClass->lire($id);
      $data["sequence_number"] = $dataClass->getLastSequenceNumber($operation_id);
      $data["sequence_id"] = 0;
      $data["uuid"] = $dataClass->getUUID();
      $dataClass->auto_date = 0;
      unset($data["date_end"]);
      $data["date_start"] = date("Y-m-d H:i:s");
      $newid = $dataClass->ecrire($data);
      $dataClass->auto_date = 1;
      if ($newid > 0) {
        $data["sequence_id"] = $newid;
        /**
         * Duplicate ambience
         */
        include_once "modules/classes/ambience.class.php";
        $ambience = new Ambience($bdd, $ObjetBDDParam);
        $dataAmbience = $ambience->getFromSequence($id);
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
        $sg = new SequenceGear($bdd, $ObjetBDDParam);
        $gears = $sg->getListFromSequence($id);
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
        unset($_REQUEST["sequence_id"]);
        $module_coderetour = 1;
      } else {
        $message->set(_("Une erreur est survenue pendant la duplication de la séquence"), true);
        $module_coderetour = -1;
      }
    }
    break;
  case "addTelemetryFish":
    $data = $_SESSION["ti_campaign"]->translateRow(
      $_SESSION["ti_operation"]->translateRow(
        $_SESSION["ti_sequence"]->translateRow(
          $dataClass->getDetail($id)
        )
      )
    );
    /**
     * Get the list of fish
     */
    include_once "modules/classes/tracking/individual_tracking.class.php";
    $indiv = new IndividualTracking($bdd, $ObjetBDDParam);
    $individuals = $indiv->getListNotInSequence($data["project_id"]);
    if (count($individuals) > 0) {
      $individuals = $_SESSION["ti_individual"]->translateList($individuals);
      $vue->set($data, "data");
      $vue->set("gestion/sequenceAddTelemetryFish.tpl", "corps");
      $vue->set($individuals, "individuals");
      $module_coderetour = 1;
    } else {
      $module_coderetour = -1;
      $message->set(_("Il n'y a pas de poissons saisis dans le module de télémétrie qui ne soient pas associés avec une séquence"), true);
    }
    break;
  case "addTelemetryFishExec":
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
      $indiv = new IndividualTracking($bdd, $ObjetBDDParam);
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
        $sampleClass = new Sample($bdd, $ObjetBDDParam);
        $individualClass = new Individual($bdd, $ObjetBDDParam);
        $bdd->beginTransaction();
        foreach ($samples as $taxonId => $sample) {
          $ds = array(
            "sample_id" => 0,
            "sequence_id" => $id,
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
        $bdd->commit();
        $message->set(_("Opération effectuée"));
        $module_coderetour = 1;
      } catch (Exception $e) {
        $message->set(_("Une erreur est survenue pendant la mise à jour des informations"), true);
        $message->setSyslog($e->getMessage());
        $bdd->rollback();
        $module_coderetour = -1;
      }
    } else {
      $module_coderetour = -1;
      $message->set(_("Aucun poisson sélectionné"), true);
    }
    break;
}
