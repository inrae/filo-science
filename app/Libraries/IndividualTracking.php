<?php

namespace App\Libraries;

use App\Models\Detection;
use App\Models\Individual;
use App\Models\IndividualTracking as ModelsIndividualTracking;
use App\Models\Pathology;
use App\Models\Project;
use App\Models\Sexe;
use App\Models\StationTracking;
use App\Models\TransmitterType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class IndividualTracking extends PpciLibrary
{
    /**
     * @var ModelsIndividualTracking
     */
    protected PpciModel $dataclass;
    public Individual $individual;
    private int $idExistent, $idMin, $idMax;
    public array $errors;
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsIndividualTracking;
        $this->keyName = "individual_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        $this->individual = new Individual;
        helper("filo");
    }


    function list()
    {
        $this->vue = service('Smarty');
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
                $detection = new Detection;
                $this->vue->set($dataStation = $detection->getStationDetection($_REQUEST["individual_id"], $delay, $year), "stationDetection");
                $this->vue->set($_REQUEST["individual_id"], "selectedIndividual");
                helper("filo");
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
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        if ($_REQUEST["individual_id"] == 0) {
            /**
             * Set the project from the cookie
             */
            $_REQUEST["project_id"] = $_COOKIE["projectId"];
        }
        if (verifyProject($_REQUEST["project_id"])) {
            $this->dataRead( $this->id, "tracking/individualTrackingChange.tpl", $_REQUEST["project_id"]);
            $sexe = new Sexe;
            $this->vue->set($sexe->getListe(1), "sexes");
            $pathology = new Pathology;
            $this->vue->set($pathology->getListe(3), "pathologys");
            $tt = new TransmitterType;
            $this->vue->set($tt->getListe("transmitter_type_name"), "transmitters");
            /**
             * Set the project
             */
            $project = new Project;
            $this->vue->set($project->getDetail($_REQUEST["project_id"]), "project");
            $this->vue->set($_SESSION["projects"], "projects");
            /**
             * Set the list of release stations
             */
            $station = new StationTracking;
            $this->vue->set($station->getListFromProject($_REQUEST["project_id"], 3), "releaseStations");
            return $this->vue->send();
        } else {
            $this->message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
            return defaultPage();
        }
    }
    function write()
    {
        if (verifyProject($_REQUEST["project_id"])) {
            try {
                $this->id == 0 ? $isNew = true : $isNew = false;
                $db = $this->dataclass->db;
                $db->transBegin();
                $individual = new Individual;
                $this->id = $individual->write($_REQUEST);
                if ($this->id > 0) {
                    if ($isNew) {
                        $_REQUEST[$this->keyName] = 0;
                    } else {
                        $_REQUEST[$this->keyName] = $this->id;
                    }
                }
                $db->transCommit();
                return true;
            } catch (PpciException $e) {
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                $this->message->set(_("Problème rencontré lors de l'enregistrement du poisson"), true);
                $this->message->setSyslog($e->getMessage());
                return false;
            }
        } else {
            $this->message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
            return false;
        }
    }
    function delete()
    {
        if (verifyProject($_REQUEST["project_id"])) {
            try {
                $db = $this->dataclass->db;
                $db->transBegin();
                $this->dataDelete($this->id, true);
                $db->transCommit();
                return true;
            } catch (PpciException $e) {
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                $this->message->set(_("Problème rencontré lors de la suppression du poisson"), true);
                $this->message->setSyslog($e->getMessage());
                return false;
            }
        } else {
            $this->message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
            return false;
        }
    }
    function export()
    {
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
                    $this->vue = service("CsvView");
                    $this->vue->set($this->dataclass->getListDetection($uid));
                    return $this->vue->send();
                } else {
                    throw new PpciException(_("Aucun poisson n'a été sélectionné"));
                }
            } else {
                throw new PpciException(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"));
            }
        } catch (PpciException $ite) {
            $this->message->set($ite->getMessage(), true);
            return false;
        }
    }
    function import()
    {
        $this->vue = service('Smarty');
        $this->vue->set("tracking/individualTrackingImport.tpl", "corps");
        $this->vue->set($_SESSION["projects"], "projects");
        if (isset($this->errors)) {
            $this->vue->set($this->errors, "errors");
            $this->vue->set(1, "error");
        }
        return $this->vue->send();
    }
    function importExec()
    {
        if (verifyProject($_POST["project_id"])) {
            $fdata = $_FILES['filename'];
            if ($fdata["error"] == 0 && $fdata["size"] > 0) {
                /**
                 * $this->errors: list of errors
                 * Structure: array ["lineNumber", "content"]
                 */
                $this->errors = array();
                $numLine = 1;
                $this->idMin = 999999999;
                $this->idMax = 0;
                $continue = true;
                $totalNumber = 0;
                try {
                    $db = $this->dataclass->db;
                    $db->transBegin();
                    $this->individual->individualTracking = $this->dataclass;
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
                                    break;
                                }
                            }
                            if ($isNew) {
                                $line["project_id"] = $_POST["project_id"];
                                $line["individual_id"] = 0;
                                $line["isTracking"] = 1;
                                $this->id = $this->individual->write($line);
                                if ($this->id < $this->idMin) {
                                    $this->idMin = $this->id;
                                }
                                if ($this->id > $this->idMax) {
                                    $this->idMax = $this->id;
                                }
                                $totalNumber++;
                            } else {
                                $this->errors[] = array(
                                    "lineNumber" => $numLine,
                                    "content" => sprintf(_("Le poisson existe déjà (id : %s)"), $this->idExistent)
                                );
                            }
                        } else {
                            $this->errors[] = array(
                                "lineNumber" => $numLine,
                                "content" => _("La ligne est vide ou le taxon_id n'a pas été renseigné - ligne non traitée")
                            );
                        }
                    }
                    $db->transCommit();
                    $this->errors[] = array("content" => _("Nombre total de poissons créés : ") . $totalNumber);
                    if ($totalNumber > 0) {
                        $this->errors[] = array("content" => _("Id mini généré : ") . $this->idMin);
                        $this->errors[] = array("content" => _("Id maxi généré : ") . $this->idMax);
                    }
                    $import->fileClose();
                    return true;
                } catch (PpciException $oe) {
                    if (!$_REQUEST["testMode"] == 1) {
                        $this->errors[] = array("lineNumber" => $numLine, "content" => _("Erreur d'écriture en table. Message d'erreur de la base de données : ") . $oe->getMessage());
                        $this->message->set(_("L'importation a échoué. Consultez les messages dans le tableau"), true);
                        $this->message->setSyslog($oe->getMessage());
                        if ($db->transEnabled) {
                            $db->transRollback();
                        }
                        $import->fileClose();
                        return false;
                    }
                }
            } else {
                $this->message->set(_("Le fichier fourni est vide ou n'a pu être téléchargé"), true);
                return false;
            }
        } else {
            $this->message->set(_("Le projet indiqué ne fait pas partie des projets qui vous sont autorisés"), true);
            return false;
        }
    }
}
