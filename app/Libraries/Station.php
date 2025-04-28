<?php

namespace App\Libraries;

use App\Models\Import;
use App\Models\Param;
use App\Models\Station as ModelsStation;
use App\Models\StationTracking;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Station extends PpciLibrary
{
    /**
     * @var ModelsStation
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsStation;
        $this->keyName = "station_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListFromproject(0, false), "data");
        $this->vue->set("param/stationList.tpl", "corps");
        $this->vue->set($_SESSION["projects"], "projects");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');

        $this->dataRead($this->id, "param/stationChange.tpl");
        setParamMap($this->vue);
        $this->vue->set($_SESSION["projects"], "projects");
        $river = new Param("river");
        $this->vue->set($river->getListe("river_name"), "rivers");
        return $this->vue->send();
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
    function import()
    {
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
                $river = new Param("river");
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
                return true;
            } catch (PpciException $e) {
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                $this->message->set(_("Impossible d'importer les stations"));
                $this->message->set($e->getMessage());
                return false;
            }
        } else {
            $this->message->set(_("Impossible de charger le fichier à importer"));
            return false;
        }
    }
    function getFromProject()
    {
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->getListFromproject($_REQUEST["project_id"]));
        return $this->vue->send();
    }
    function getCoordinate()
    {
        $this->vue = service("AjaxView");
        $this->vue->set($this->dataclass->getCoordinates($_REQUEST["station_id"]));
        return $this->vue->send();
    }
}
