<?php
include_once 'modules/classes/tracking/individual_tracking.class.php';
$dataClass = new IndividualTracking($bdd, $ObjetBDDParam);
$keyName = "individual_id";
$id = $_REQUEST[$keyName];
require_once 'modules/classes/individual.class.php';
$individual = new Individual($bdd, $ObjetBDDParam);

switch ($t_module["param"]) {
  case "list":
    include_once 'modules/classes/project.class.php';
    $project = new Project($bdd, $ObjetBDDParam);
    isset($_COOKIE["projectId"]) ? $project_id = $_COOKIE["projectId"] : $project_id = 0;
    isset($_COOKIE["projectActive"]) ? $is_active = $_COOKIE["projectActive"] : $is_active = 1;
    $vue->set($projects = $project->getProjectsActive($is_active, $_SESSION["projects"]), "projects");
    $vue->set($is_active, "is_active");
    if ($project_id > 0 && !verifyProject($project_id)) {
      $project_id = $projects[0]["project_id"];
    }
    if (!$project_id > 0) {
      $project_id = $projects[0]["project_id"];
    }
    $vue->set($dataClass->getListFromProject($project_id), "individuals");
    $vue->set("tracking/individualTrackingList.tpl", "corps");
    $vue->set($project_id, "project_id");
    if ($_REQUEST["individual_id"] > 0) {
      $dindividual = $dataClass->getDetail($_REQUEST["individual_id"]);
      if ($dindividual["project_id"] == $project_id) {
        $vue->set($dindividual, "individual");
        /**
         * Manage offset
         */
        $_REQUEST["offset"] > 0 ? $offset = $_REQUEST["offset"] : $offset = 0;
        $vue->set($offset, "offset");
        $vue->set($dataClass->getListDetection($_REQUEST["individual_id"], 'YYYY-MM-DD HH24:MI:SS.MS', "detection_date asc", 100, $offset), "detections");
        $vue->set($dataClass->getDetectionNumberByDate($_REQUEST["individual_id"]), "detection_number");
        /**
         * Get the detections grouped by station
         */
        include_once "modules/classes/tracking/detection.class.php";
        $detection = new Detection($bdd, $ObjetBDDParam);
        $vue->set($dataStation = $detection->getStationDetection($_REQUEST["individual_id"]), "stationDetection");
        $vue->set($_REQUEST["individual_id"], "selectedIndividual");
        setParamMap($vue, false);
        /**
         * Generate data for graphs
         */
        $axisx = array("x");
        $axisy = array("detection");
        $stations = array();
        foreach ($dataStation as $row) {
          $axisx[] = substr($row["date_from"],0, 19);
          $axisy[] = $row["station_number"];
          if (!in_array($row["station_number"], $stations)) {
            $stations[]  = $row["station_number"];
          }
        }
        sort($stations);
        $vue->set(json_encode($stations), "stations");
        $chart = array($axisx, $axisy);
        //printA(json_encode($chart));
        $vue->set(json_encode($chart), "chartData");
        /**
         * Inhibits the encoding of chartData
         */
        $vue->htmlVars[] = "chartData";
        $vue->htmlVars[] = "stations";
      }
    }
    break;
  case "change":
    if ($_REQUEST["individual_id"] == 0) {
      /**
       * Set the project from the cookie
       */
      $_REQUEST["project_id"] = $_COOKIE["projectId"];
    }
    if (verifyProject($_REQUEST["project_id"])) {
      $data = dataRead($individual, $id, "tracking/individualTrackingChange.tpl", $_REQUEST["project_id"]);
      require_once 'modules/classes/sexe.class.php';
      $sexe = new Sexe($bdd, $ObjetBDDParam);
      $vue->set($sexe->getListe(1), "sexes");
      require_once 'modules/classes/pathology.class.php';
      $pathology = new Pathology($bdd, $ObjetBDDParam);
      $vue->set($pathology->getListe(3), "pathologys");
      include_once 'modules/classes/tracking/transmitter_type.class.php';
      $tt = new TransmitterType($bdd, $ObjetBDDParam);
      $vue->set($tt->getListe("transmitter_type_name"), "transmitters");
      /**
       * Set the project
       */
      include_once 'modules/classes/project.class.php';
      $project = new Project($bdd, $ObjetBDDParam);
      $vue->set($project->getDetail($_REQUEST["project_id"]), "project");
      $vue->set($_SESSION["projects"], "projects");
      /**
       * Set the list of release stations
       */
      include_once "modules/classes/tracking/station_tracking.class.php";
      $station = new StationTracking($bdd, $ObjetBDDParam);
      $vue->set($station->getListFromProject($_REQUEST["project_id"], 3), "releaseStations");
    } else {
      $module_coderetour = -1;
      $message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
    }
    break;
  case "write":
    if (verifyProject($_REQUEST["project_id"])) {
      try {
        $id == 0 ? $isNew = true : $isNew = false;
        $bdd->beginTransaction();
        $id = dataWrite($individual, $_REQUEST, true);
        if ($id > 0) {
          if ($isNew) {
            $t_module["retourok"] = "individualTrackingChange";
            $_REQUEST[$keyName] = 0;
          } else {
            $_REQUEST[$keyName] = $id;
          }
        }
        $module_coderetour = 1;
        $bdd->commit();
      } catch (Exception $e) {
        $bdd->rollback();
        $message->set(_("Problème rencontré lors de l'enregistrement du poisson"), true);
        $message->setSyslog($e->getMessage());
        $module_coderetour = -1;
      }
    } else {
      $module_coderetour = -1;
      $message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
    }
    break;
  case "delete":
    if (verifyProject($_REQUEST["project_id"])) {
      try {
        $bdd->beginTransaction();
        dataDelete($individual, $id, true);
        $bdd->commit();
        $module_coderetour = 1;
      } catch (Exception $e) {
        $bdd->rollback();
        $message->set(_("Problème rencontré lors de la suppression du poisson"), true);
        $message->setSyslog($e->getMessage());
        $module_coderetour = -1;
      }
    } else {
      $module_coderetour = -1;
      $message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
    }
    break;
  case "export":
    /**
     * Export the list of detections for all selected fish
     */
    try {
      if (verifyProject($_POST["project_id"])) {
        if (is_array($_POST["uids"])) {
          $uid = $_POST["uids"];
        } else {
          $uid = array($_POST["uids"]);
        }
        if ($uid[0] > 0) {
          $vue->set($dataClass->getListDetection($uid));
        } else {
          throw new IndividualTrackingException(_("Aucun poisson n'a été sélectionné"));
        }
      } else {
        throw new IndividualTrackingException(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"));
      }
    } catch (IndividualTrackingException $ite) {
      $message->set($ite->getMessage(), true);
      $module_coderetour = -1;
      unset($vue);
    }
    break;
  case "import":
    $vue->set("tracking/individualTrackingImport.tpl", "corps");
    $vue->set($_SESSION["projects"], "projects");
    if (isset($errors)) {
      $vue->set($errors, "errors");
      $vue->set(1, "error");
    }
    break;
  case "importExec":
    if (verifyProject($_POST["project_id"])) {
      $fdata = $_FILES['filename'];
      if ($fdata["error"] == 0 && $fdata["size"] > 0) {
        /**
         * $errors: list of errors
         * Structure: array ["lineNumber", "content"]
         */
        $errors = array();
        $numLine = 1;
        $idMin = 999999999;
        $idMax = 0;
        $continue = true;
        $totalNumber = 0;
        include_once "modules/classes/tracking/import.class.php";
        try {
          $bdd->beginTransaction();
          $individual->individualTracking = $dataClass;
          $import = new ImportTracking($fdata["tmp_name"], $_POST["separator"]);
          $lines = $import->getContentAsArray();
          $fields = array("uuid", "individual_code", "tag", "transmitter");
          foreach ($lines as $line) {
            $numLine++;
            /**
             * Search if the line is empty (taxon_id empty)
             */
            if (strlen($line["taxon_id"]) > 0) {
              /**
               * Search if the fish exists
               */
              $isNew = true;
              foreach ($fields as $field) {
                $idExistent = $dataClass->getIdFromField($field, $line[$field], $_POST["project_id"]);
                if ($idExistent > 0) {
                  $isNew = false;
                  break;
                }
              }
              if ($isNew) {
                $line["project_id"] = $_POST["project_id"];
                $line["individual_id"] = 0;
                $line["isTracking"] = 1;
                $id = $individual->ecrire($line);
                if ($id < $idMin) {
                  $idMin = $id;
                }
                if ($id > $idMax) {
                  $idMax = $id;
                }
                $totalNumber++;
              } else {
                $errors[] = array(
                  "lineNumber" => $numLine,
                  "content" => sprintf(_("Le poisson existe déjà (id : %s)"), $idExistent)
                );
              }
            } else {
              $errors[] = array(
                "lineNumber" => $numLine,
                "content" => _("La ligne est vide ou le taxon_id n'a pas été renseigné - ligne non traitée")
              );
            }
          }
          $bdd->commit();
          $errors[] = array("content" => _("Nombre total de poissons créés :") . $totalNumber);
          if ($totalNumber > 0) {
            $errors[] = array("content" => _("Id mini généré :") . $idMin);
            $errors[] = array("content" => _("Id maxi généré :") . $idMax);
          }
          $module_coderetour = 1;
        } catch (ImportException $ie) {
          $message->set(_("L'importation a échoué, le fichier n'a pas été correctement lu"), true);
          $message->setSyslog($ie->getMessage());
          $bdd->rollback();
          $module_coderetour = -1;
        } catch (ObjetBDDException $oe) {
          if (!$_REQUEST["testMode"] == 1) {
            $errors[] = array("lineNumber" => $numLine, "content" => _("Erreur d'écriture en table. Message d'erreur de la base de données : ") . $oe->getMessage());
            $message->set(_("L'importation a échoué. Consultez les messages dans le tableau"), true);
            $message->setSyslog($oe->getMessage());
            $bdd->rollback();
            $module_coderetour = -1;
          }
        } catch (Exception $e) {
          $bdd->rollback();
          $module_coderetour = -1;
        } finally {
          $import->fileClose();
        }
      } else {
        $module_coderetour = -1;
        $message->set(_("Le fichier fourni est vide ou n'a pu être téléchargé"), true);
      }
    } else {
      $module_coderetour = -1;
      $message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
    }
    break;
}
