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
include_once 'modules/classes/tracking/individual_tracking.class.php';
$this->dataclass = new IndividualTracking;
$keyName = "individual_id";
$this->id = $_REQUEST[$keyName];
require_once 'modules/classes/individual.class.php';
$individual = new Individual;


  function list()
{
$this->vue=service('Smarty');
    include_once 'modules/classes/project.class.php';
    $project = new Project;
    isset($_COOKIE["projectId"]) ? $project_id = $_COOKIE["projectId"] : $project_id = 0;
    isset($_COOKIE["projectActive"]) ? $is_active = $_COOKIE["projectActive"] : $is_active = 1;
    isset($_COOKIE["delay"]) ? $delay = $_COOKIE["delay"] : $delay = 3600;
    $this->vue->set($projects = $project->getProjectsActive($is_active, $_SESSION["projects"]), "projects");
    $this->vue->set($is_active, "is_active");
    $this->vue->set($delay, "delay");
    if ($project_id > 0 && !verifyProject($project_id)) {
      $project_id = $projects[0]["project_id"];
    }
    if (!$project_id > 0) {
      $project_id = $projects[0]["project_id"];
    }
    isset($_COOKIE["taxon_id"]) ? $taxon_id = $_COOKIE["taxon_id"] : $taxon_id = 0;
    isset($_COOKIE["year"]) ? $year = $_COOKIE["year"] : $year = 0;
    if ($project_id > 0) {
      $this->vue->set($this->dataclass->getListFromProject($project_id, $year, $taxon_id), "individuals");
    }
    $this->vue->set("tracking/individualTrackingList.tpl", "corps");
    $this->vue->set($project_id, "project_id");
    /**
     * Get list of years and taxa
     */
    if ($project_id > 0) {
      $this->vue->set($this->dataclass->getListYearFromProject($project_id), "years");
      $this->vue->set($this->dataclass->getListTaxaFromProject($project_id), "taxa");
    }
    if ($_REQUEST["individual_id"] > 0) {
      $dindividual = $this->dataclass->getDetail($_REQUEST["individual_id"]);
      if ($dindividual["project_id"] == $project_id) {
        $this->vue->set($dindividual, "individual");
        /**
         * Manage offset
         */
        $_REQUEST["offset"] > 0 ? $offset = $_REQUEST["offset"] : $offset = 0;
        $this->vue->set($offset, "offset");
        $this->vue->set($this->dataclass->getListDetection($_REQUEST["individual_id"], 'YYYY-MM-DD HH24:MI:SS.MS', "detection_date asc", 100, $offset, $year), "detections");
        $this->vue->set($this->dataclass->getDetectionNumberByDate($_REQUEST["individual_id"], $year), "detection_number");
        /**
         * Get the detections grouped by station
         */
        include_once "modules/classes/tracking/detection.class.php";
        $detection = new Detection;
        $this->vue->set($dataStation = $detection->getStationDetection($_REQUEST["individual_id"], $delay, $year), "stationDetection");
        $this->vue->set($_REQUEST["individual_id"], "selectedIndividual");
        setParamMap($this->vue, false);
        /**
         * Generate data for graphs
         */
        $axisx1 = array("x1");
        $axisy1 = array("detection");
        $stations = array();
        $datemin = '2050-12-31 23:59:59';
        $datemax = '1970-01-01 00:00:00';
        $graphdata = array();
        foreach ($dataStation as $row) {
          $date_from = substr($row["date_from"], 0, 19);
          $axisx1[] = $date_from;
          $axisy1[] = $row["station_number"];
          $date_to = substr($row["date_to"], 0, 19);
          $axisx1[] = $date_to;
          if ($date_from < $datemin) {
            $datemin = $date_from;
          }
          if ($date_to > $datemax) {
            $datemax = $date_to;
          }
          $graphdata[] = array("date" => $date_from, "detection" => $row["station_number"]);
          $graphdata[] = array("date" => $date_to, "detection" => $row["station_number"]);
          $axisy1[] = $row["station_number"];
          if (!in_array($row["station_number"], $stations)) {
            $stations[] = $row["station_number"];
          }
        }
        sort($stations);
        /**
         * Get the presence of stations between the dates
         */
        include_once "modules/classes/tracking/station_tracking.class.php";
        $stationTracking = new StationTracking;
        $axisx2 = array("x2");
        $axisy2 = array("stations");
        $series = array();
        $regions = array();
        foreach ($stations as $station) {
          if (!empty($station)) {
            $presences = $stationTracking->getPresenceStation($project_id, $station, $datemin, $datemax);
            foreach ($presences as $presence) {
              $presence["date_from"] < $datemin ? $datefrom = $datemin : $datefrom = $presence["date_from"];
              $presence["date_to"] > $datemax ? $dateto = $datemax : $dateto = $presence["date_to"];
              $axisx2[] = $datefrom;
              $axisy2[] = $presence["station_number"];
              $axisx2[] = $dateto;
              $axisy2[] = $presence["station_number"];
              $graphdata[] = array("date" => $datefrom, "station" . $presence["station_number"] => $presence["station_number"]);
              $graphdata[] = array("date" => $dateto, "station" . $presence["station_number"] => $presence["station_number"]);
              $regions["station" . $presence["station_number"]][] = array("start" => $datefrom, "end" => $dateto/*, "style"=>"dashed"*/);
            }
            $series[] = "station" . $station;
          }
        }
        $series[] = "detection";
        $this->vue->set(json_encode($stations), "stations");
        $this->vue->set(json_encode($regions), "regions");
        $chart2 = array($axisx1, $axisx2, $axisy1, $axisy2);
        $this->vue->set(json_encode($chart2), "chartData2");
        usort($graphdata, function ($a, $b) {
          return $a["date"] <=> $b["date"];
        });
        $this->vue->set(json_encode(($graphdata)), "graphdata");
        $this->vue->set(json_encode($series), "series");
        /**
         * Inhibits the encoding of chartData
         */
        $this->vue->htmlVars[] = "stations";
        $this->vue->htmlVars[] = "chartData2";
        $this->vue->htmlVars[] = "graphdata";
        $this->vue->htmlVars[] = "series";
        $this->vue->htmlVars[] = "regions";
      }
    }
    }
  function change()
{
$this->vue=service('Smarty');
    if ($_REQUEST["individual_id"] == 0) {
      /**
       * Set the project from the cookie
       */
      $_REQUEST["project_id"] = $_COOKIE["projectId"];
    }
    if (verifyProject($_REQUEST["project_id"])) {
      $data = dataRead($individual, $this->id, "tracking/individualTrackingChange.tpl", $_REQUEST["project_id"]);
      require_once 'modules/classes/sexe.class.php';
      $sexe = new Sexe;
      $this->vue->set($sexe->getListe(1), "sexes");
      require_once 'modules/classes/pathology.class.php';
      $pathology = new Pathology;
      $this->vue->set($pathology->getListe(3), "pathologys");
      include_once 'modules/classes/tracking/transmitter_type.class.php';
      $tt = new TransmitterType;
      $this->vue->set($tt->getListe("transmitter_type_name"), "transmitters");
      /**
       * Set the project
       */
      include_once 'modules/classes/project.class.php';
      $project = new Project;
      $this->vue->set($project->getDetail($_REQUEST["project_id"]), "project");
      $this->vue->set($_SESSION["projects"], "projects");
      /**
       * Set the list of release stations
       */
      include_once "modules/classes/tracking/station_tracking.class.php";
      $station = new StationTracking;
      $this->vue->set($station->getListFromProject($_REQUEST["project_id"], 3), "releaseStations");
    } else {
      $module_coderetour = -1;
      $this->message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
    }
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
    if (verifyProject($_REQUEST["project_id"])) {
      try {
        $this->id == 0 ? $isNew = true : $isNew = false;
        $db = $this->dataclass->db;
$db->transBegin();
        $this->id = dataWrite($individual, $_REQUEST, true);
        if ($this->id > 0) {
          if ($isNew) {
            $t_module["retourok"] = "individualTrackingChange";
            $_REQUEST[$keyName] = 0;
          } else {
            $_REQUEST[$keyName] = $this->id;
          }
        }
        $module_coderetour = 1;
        $db->transCommit();
      } catch (Exception $e) {
        if ($db->transEnabled) {
    $db->transRollback();
}
        $this->message->set(_("Problème rencontré lors de l'enregistrement du poisson"), true);
        $this->message->setSyslog($e->getMessage());
        $module_coderetour = -1;
      }
    } else {
      $module_coderetour = -1;
      $this->message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
    }
    }
  function delete()
{
    if (verifyProject($_REQUEST["project_id"])) {
      try {
        $db = $this->dataclass->db;
$db->transBegin();
        dataDelete($individual, $this->id, true);
        $db->transCommit();
        $module_coderetour = 1;
      } catch (Exception $e) {
        if ($db->transEnabled) {
    $db->transRollback();
}
        $this->message->set(_("Problème rencontré lors de la suppression du poisson"), true);
        $this->message->setSyslog($e->getMessage());
        $module_coderetour = -1;
      }
    } else {
      $module_coderetour = -1;
      $this->message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
    }
    }
  function export() {
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
          $this->vue->set($this->dataclass->getListDetection($uid));
        } else {
          throw new IndividualTrackingException(_("Aucun poisson n'a été sélectionné"));
        }
      } else {
        throw new IndividualTrackingException(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"));
      }
    } catch (IndividualTrackingException $ite) {
      $this->message->set($ite->getMessage(), true);
      $module_coderetour = -1;
      unset($this->vue);
    }
    }
  function import() {
    $this->vue->set("tracking/individualTrackingImport.tpl", "corps");
    $this->vue->set($_SESSION["projects"], "projects");
    if (isset($errors)) {
      $this->vue->set($errors, "errors");
      $this->vue->set(1, "error");
    }
    }
  function importExec() {
    if (verifyProject($_POST["project_id"])) {
      $fdata = $_FILES['filename'];
      if ($fdata["error"] == 0 && $fdata["size"] > 0) {
        /**
         * $errors: list of errors
         * Structure: array ["lineNumber", "content"]
         */
        $errors = array();
        $numLine = 1;
        $this->idMin = 999999999;
        $this->idMax = 0;
        $continue = true;
        $totalNumber = 0;
        include_once "modules/classes/tracking/import.class.php";
        try {
          $db = $this->dataclass->db;
$db->transBegin();
          $individual->individualTracking = $this->dataclass;
          $import = new ImportTracking($fdata["tmp_name"], $_POST["separator"]);
          $lines = $import->getContentAsArray();
          $fields = array("uuid", "individual_code", "tag", "transmitter");
          foreach ($lines as $line) {
            $numLine++;
            /**
             * Search if the line is empty (taxon_id empty)
             */
            if (!empty($line["taxon_id"])) {
              /**
               * Search if the fish exists
               */
              $isNew = true;
              foreach ($fields as $field) {
                $this->idExistent = $this->dataclass->getIdFromField($field, $line[$field], $_POST["project_id"]);
                if ($this->idExistent > 0) {
                  $isNew = false;
                  }
                }
              }
              if ($isNew) {
                $line["project_id"] = $_POST["project_id"];
                $line["individual_id"] = 0;
                $line["isTracking"] = 1;
                $this->id = $individual->ecrire($line);
                if ($this->id < $this->idMin) {
                  $this->idMin = $this->id;
                }
                if ($this->id > $this->idMax) {
                  $this->idMax = $this->id;
                }
                $totalNumber++;
              } else {
                $errors[] = array(
                  "lineNumber" => $numLine,
                  "content" => sprintf(_("Le poisson existe déjà (id : %s)"), $this->idExistent)
                );
              }
            } else {
              $errors[] = array(
                "lineNumber" => $numLine,
                "content" => _("La ligne est vide ou le taxon_id n'a pas été renseigné - ligne non traitée")
              );
            }
          }
          $db->transCommit();
          $errors[] = array("content" => _("Nombre total de poissons créés :") . $totalNumber);
          if ($totalNumber > 0) {
            $errors[] = array("content" => _("Id mini généré :") . $this->idMin);
            $errors[] = array("content" => _("Id maxi généré :") . $this->idMax);
          }
          $module_coderetour = 1;
        } catch (ImportException $ie) {
          $this->message->set(_("L'importation a échoué, le fichier n'a pas été correctement lu"), true);
          $this->message->setSyslog($ie->getMessage());
          if ($db->transEnabled) {
    $db->transRollback();
}
          $module_coderetour = -1;
        } catch (ObjetBDDException $oe) {
          if (!$_REQUEST["testMode"] == 1) {
            $errors[] = array("lineNumber" => $numLine, "content" => _("Erreur d'écriture en table. Message d'erreur de la base de données : ") . $oe->getMessage());
            $this->message->set(_("L'importation a échoué. Consultez les messages dans le tableau"), true);
            $this->message->setSyslog($oe->getMessage());
            if ($db->transEnabled) {
    $db->transRollback();
}
            $module_coderetour = -1;
          }
        } catch (Exception $e) {
          if ($db->transEnabled) {
    $db->transRollback();
}
          $module_coderetour = -1;
        } finally {
          $import->fileClose();
        }
      } else {
        $module_coderetour = -1;
        $this->message->set(_("Le fichier fourni est vide ou n'a pu être téléchargé"), true);
      }
    } else {
      $module_coderetour = -1;
      $this->message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
    }
    }
}
