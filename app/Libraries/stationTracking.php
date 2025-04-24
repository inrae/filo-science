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
include_once 'modules/classes/tracking/station_tracking.class.php';
$this->dataclass = new StationTracking;
$keyName = "station_id";
$this->id = $_REQUEST[$keyName];


    function list()
{
$this->vue=service('Smarty');
        include_once 'modules/classes/project.class.php';
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
        $axisy = array ("stations");
        $series = array();
        $regions = array();
        $graphStations = array();
        foreach ($stations as $station) {
            if (!empty($station)&& !empty($station["station_number"])) {
                $presences = $this->dataclass->getPresenceStation($project_id, $station["station_number"]);
                $graphStations[] = $station["station_number"];
                foreach ($presences as $presence) {
                    $datefrom = substr($presence["date_from"],0, 19);
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
        }
    function display()
{
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set("tracking/stationTrackingDisplay.tpl", "corps");
        setParamMap($this->vue, false);
        /**
         * Get antennas
         */
        require_once "modules/classes/tracking/antenna.class.php";
        $antenna = new Antenna;
        $this->vue->set($antenna->getListFromParent($this->id, "antenna_code"), "antennas");
        /**
         * Get probes
         */
        require_once 'modules/classes/tracking/probe.class.php';
        $probe = new Probe;
        $this->vue->set($probe->getListFromParent($this->id), "probes");
        if (isset($_REQUEST["probe_id"])) {
            /**
             * Get the last measures for the probe
             */
            include_once "modules/classes/tracking/probe_measure.class.php";
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
        }
    function change()
{
$this->vue=service('Smarty');
        /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
        $data = $this->dataRead( $this->id, "tracking/stationTrackingChange.tpl");
        if ($this->id == 0 && isset($_COOKIE["project_id"])) {
            $data["project_id"] = $_COOKIE["project_id"];
            $this->vue->set($data, "data");
        }
        $this->vue->set($_SESSION["projects"], "projects");
        include_once 'modules/classes/param.class.php';
        $stationType = new Param($bdd, "station_type");
        $this->vue->set($stationType->getListe(1), "stationsType");
        require_once 'modules/classes/param.class.php';
        $river = new Param($bdd, "river");
        $this->vue->set($river->getListe("river_name"), "rivers");
        setParamMap($this->vue, true);
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
            $module_coderetour = -1;
            $this->message->set(_("La station n'est pas associée à un projet pour lequel vous disposez des droits de modification"), true);
        } else {
            /**
             * write record in database
             */
            $this->id = dataWrite($this->dataclass, $_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$keyName] = $this->id;
            }
        }
        }
    function delete()
{
        /**
         * Verify if the station is in the authorized projects
         */
        if ($_REQUEST["station_id"] > 0) {
            $data = $this->dataclass->lire($_request["id"]);
            $project_id = $data["project_id"];
        } else {
            $project_id = $_REQUEST["project_id"];
        }
        if (!in_array($project_id, $_SESSION["projects"])) {
            $module_coderetour = -1;
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
    function getSensors() {
        if (verifyProject($_REQUEST["project_id"])) {
            /**
             * Get the type of import
             */
            include_once "modules/classes/import/import_description.class.php";
            $this->id = new ImportDescription($bdd);
            $did = $this->id->lire($_REQUEST["import_description_id"]);
            $this->vue->set($this->dataclass->getListSensor($_REQUEST["project_id"], $did["import_type_id"]));
        }
        }
}
