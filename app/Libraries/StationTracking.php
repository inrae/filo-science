<?php

namespace App\Libraries;

use App\Models\Antenna;
use App\Models\ImportDescription;
use App\Models\Param;
use App\Models\Probe;
use App\Models\ProbeMeasure;
use App\Models\Project;
use App\Models\StationTracking as ModelsStationTracking;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class StationTracking extends PpciLibrary
{
    /**
     * @var ModelsStationTracking
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsStationTracking;
        $this->keyName = "station_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        $project = new Project;
        isset($_COOKIE["projectId"]) ? $project_id = $_COOKIE["projectId"] : $project_id = 0;
        isset($_COOKIE["projectActive"]) ? $is_active = $_COOKIE["projectActive"] : $is_active = 1;
        $this->vue->set($projects = $project->getProjectsActive($is_active, $_SESSION["projects"]), "projects");
        if ($project_id > 0 && !verifyProject($project_id)) {
            $project_id = $projects[0]["project_id"];
        }
        if (!$project_id > 0) {
            $project_id = $projects[0]["project_id"];
        }
        if (empty($project_id)) {
            $project_id = 0;
        }
        $_COOKIE["stationActive"] == 1 ? $stationActive = true : $stationActive = false;
        $stations = $this->dataclass->getListFromProject($project_id, 0, $stationActive);
        $this->vue->set($stations, "stations");
        $this->vue->set("tracking/stationTrackingList.tpl", "corps");
        /**
         * Generate the graph of station working
         */
        $graphdata = array();
        $axisx = array("x");
        $axisy = array("stations");
        $series = array();
        $regions = array();
        $graphStations = array();
        foreach ($stations as $station) {
            if (!empty($station) && !empty($station["station_number"])) {
                $presences = $this->dataclass->getPresenceStation($project_id, $station["station_number"]);
                $graphStations[] = $station["station_number"];
                foreach ($presences as $presence) {
                    $datefrom = substr($presence["date_from"], 0, 19);
                    $dateto = substr($presence["date_to"], 0, 19);
                    $axisx[] = $datefrom;
                    $axisy[] = $presence["station_number"];
                    $axisx[] = $dateto;
                    $axisy[] = $presence["station_number"];
                    $graphdata[] = array("date" => $datefrom, $station["station_name"] => $presence["station_number"]);
                    $graphdata[] = array("date" => $dateto, $station["station_name"] => $presence["station_number"]);
                    $regions[$station["station_name"]][] = array("start" => $datefrom, "end" => $dateto/*, "style"=>"dashed"*/);
                }
                $series[] = $station["station_name"];
            }
        }
        $this->vue->set(json_encode($graphStations), "graphStations");
        $this->vue->set(json_encode($regions), "regions");
        $chart = array($axisx, $axisy);
        $this->vue->set(json_encode($chart), "chartData");
        usort($graphdata, function ($a, $b) {
            return $a["date"] <=> $b["date"];
        });
        $this->vue->set(json_encode(($graphdata)), "graphdata");
        $this->vue->set(json_encode($series), "series");
        /**
         * Inhibits the encoding of chartData
         */
        $this->vue->htmlVars[] = "graphStations";
        $this->vue->htmlVars[] = "chartData";
        $this->vue->htmlVars[] = "graphdata";
        $this->vue->htmlVars[] = "series";
        $this->vue->htmlVars[] = "regions";
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set("tracking/stationTrackingDisplay.tpl", "corps");
        setParamMap($this->vue, false);
        /**
         * Get antennas
         */
        $antenna = new Antenna;
        $this->vue->set($antenna->getListFromParent($this->id, "antenna_code"), "antennas");
        /**
         * Get probes
         */
        $probe = new Probe;
        $this->vue->set($probe->getListFromParent($this->id), "probes");
        if (isset($_REQUEST["probe_id"])) {
            /**
             * Get the last measures for the probe
             */
            $pm = new ProbeMeasure;

            if (!isset($_REQUEST["limit"])) {
                $_REQUEST["limit"] = 30;
            }
            if (!isset($_REQUEST["offset"]) || $_REQUEST["offset"] < 0) {
                $_REQUEST["offset"] = 0;
            }
            $this->vue->set($pm->getMeasures($_REQUEST["probe_id"], $_REQUEST["limit"], $_REQUEST["offset"]), "measures");
            $this->vue->set($_REQUEST["limit"], "limit");
            $this->vue->set($_REQUEST["offset"], "offset");
            $this->vue->set($_REQUEST["probe_id"], "selectedProbe");
        }
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $data = $this->dataRead($this->id, "tracking/stationTrackingChange.tpl");
        if ($this->id == 0 && isset($_COOKIE["project_id"])) {
            $data["project_id"] = $_COOKIE["project_id"];
            $this->vue->set($data, "data");
        }
        $this->vue->set($_SESSION["projects"], "projects");
        $stationType = new Param("station_type");
        $this->vue->set($stationType->getListe(1), "stationsType");
        $river = new Param("river");
        $this->vue->set($river->getListe("river_name"), "rivers");
        setParamMap($this->vue, true);
        return $this->vue->send();
    }
    function write()
    {
        try {

            /**
             * Verify if the station is in the authorized projects
             */
            if ($_REQUEST["station_id"] > 0) {
                $data = $this->dataclass->lire($_REQUEST["station_id"]);
                $project_id = $data["project_id"];
            } else {
                $project_id = $_REQUEST["project_id"];
            }
            if (!verifyProject($project_id)) {
                return false;
                $this->message->set(_("La station n'est pas associée à un projet pour lequel vous disposez des droits de modification"), true);
            } else {
                /**
                 * write record in database
                 */
                $this->id = $this->dataWrite($_REQUEST);
                if ($this->id > 0) {
                    $_REQUEST[$this->keyName] = $this->id;
                }
            }
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }
    function delete()
    {
        /**
         * Verify if the station is in the authorized projects
         */
        if ($_REQUEST["station_id"] > 0) {
            $data = $this->dataclass->lire($_REQUEST["station_id"]);
            $project_id = $data["project_id"];
        } else {
            $project_id = $_REQUEST["project_id"];
        }
        if (!in_array($project_id, $_SESSION["projects"])) {
            return false;
            $this->message->set(_("La station n'est pas associée à un projet pour lequel vous disposez des droits de modification"), true);
        } else {
            /**
             * delete record
             */
            try {
                $this->dataDelete($this->id);
                return true;
            } catch (PpciException $e) {
                return false;
            };
        }
    }
    function getSensors()
    {
        if (verifyProject($_REQUEST["project_id"])) {
            $this->vue = service("AjaxView");
            /**
             * Get the type of import
             */
            $importDescription = new ImportDescription;
            $did = $importDescription->lire($_REQUEST["import_description_id"]);
            $this->vue->set($this->dataclass->getListSensor($_REQUEST["project_id"], $did["import_type_id"]));
            return $this->vue->send();
        }
    }
}
