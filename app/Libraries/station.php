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
require_once 'modules/classes/station.class.php';
$this->dataclass = new station;
$keyName = "station_id";
$this->id = $_REQUEST[$keyName];


    function list()
{
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListFromproject(0, false), "data");
        $this->vue->set("param/stationList.tpl", "corps");
        $this->vue->set($_SESSION["projects"], "projects");
        }
    function change()
{
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/stationChange.tpl");
        setParamMap($this->vue);
        $this->vue->set($_SESSION["projects"], "projects");
        require_once 'modules/classes/param.class.php';
        $river = new Param($bdd, "river");
        $this->vue->set($river->getListe("river_name"), "rivers");
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
        $this->id = dataWrite($this->dataclass, $_REQUEST);
        if ($this->id > 0) {
            $_REQUEST[$keyName] = $this->id;
        }
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
        }
    function import() {
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            require_once 'modules/classes/import.class.php';
            $i = 0;
            try {
                $db = $this->dataclass->db;
$db->transBegin();
                $import = new Import($_FILES['upfile']['tmp_name'], $_POST["separator"], false, array(
                    "name",
                    "code",
                    "long",
                    "lat",
                    "pk",
                    "river",
                    "number",
                    "station_type_id"
                ));
                require_once 'modules/classes/param.class.php';
                $river = new Param($bdd, "river");
                require_once "modules/classes/tracking/station_tracking.class.php";
                $stationTracking = new StationTracking;
                $rows = $import->getContentAsArray();
                foreach ($rows as $row) {
                    if (!empty($row["name"])) {
                        /*
                         * Ecriture en base, en mode ajout ou modification
                         */
                        $data = array(
                            "station_name" => $row["name"],
                            "project_id" => $_POST["project_id"],
                            "station_code" => $row["code"],
                            "station_long" => $row["long"],
                            "station_lat" => $row["lat"],
                            "station_pk" => $row["pk"],
                            "station_number" => $row["number"],
                            "station_id" => $this->dataclass->getIdFromName($row["name"]),
                            "station_type_id" => $row["station_type_id"]
                        );
                        if (!empty($row["river"])) {
                            $data["river_id"] = $river->getIdFromName($row["river"], true);
                        }
                        $station_id = $this->dataclass->ecrire($data);
                        if (!empty($data["station_type_id"]) && $station_id > 0) {
                            /**
                             * Write the type of tracking station
                             */
                            $dataTracking = array(
                                "station_id" => $station_id,
                                "station_type_id" => $data["station_type_id"],
                                "station_active" => 1
                            );
                            $stationTracking->ecrire($dataTracking);
                        }
                        $i++;
                    }
                }
                $db->transCommit();
                $this->message->set(sprintf(_("%d stations(s) importée(s)"), $i));
                $module_coderetour = 1;
            } catch (Exception $e) {
                if ($db->transEnabled) {
    $db->transRollback();
}
                $this->message->set(_("Impossible d'importer les stations"));
                $this->message->set($e->getMessage());
                $module_coderetour = -1;
            }
        } else {
            $this->message->set(_("Impossible de charger le fichier à importer"));
            $module_coderetour = -1;
        }
        }
    function getFromProject() {
        $this->vue->set($this->dataclass->getListFromproject($_REQUEST["project_id"]));
        }
    function getCoordinate() {
        $this->vue->set($this->dataclass->getCoordinates($_REQUEST["station_id"]));
        }
}
