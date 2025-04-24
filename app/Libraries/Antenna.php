<?php

namespace App\Libraries;

use App\Models\Antenna as ModelsAntenna;
use App\Models\Param;
use App\Models\StationTracking;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Antenna extends PpciLibrary
{
    /**
     * @var ModelsAntenna
     */
    protected PpciModel $dataclass;
    public StationTracking $stationTracking;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsAntenna;
        $this->stationTracking = new StationTracking;
        $this->keyName = "antenna_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function change()
    {
        if (!$this->stationTracking->verifyProject($_REQUEST["station_id"])) {
            $this->message->set(_("La station ne fait partie d'un projet autorisé"), true);
            return defaultPage();
        }
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "tracking/antennaChange.tpl", $_REQUEST["station_id"]);
        $this->vue->set($this->stationTracking->lire($_REQUEST["station_id"]), "station");
        $technology = new Param("technology_type");
        $this->vue->set($technology->getListe(1), "technologies");
        return $this->vue->send();
    }
    function write()
    {
        if (!$this->stationTracking->verifyProject($_REQUEST["station_id"])) {
            $this->message->set(_("La station ne fait partie d'un projet autorisé"), true);
            return defaultPage();
        }
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
        if (!$this->stationTracking->verifyProject($_REQUEST["station_id"])) {
            $this->message->set(_("La station ne fait partie d'un projet autorisé"), true);
            return defaultPage();
        }
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
