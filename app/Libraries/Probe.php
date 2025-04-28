<?php

namespace App\Libraries;

use App\Models\Probe as ModelsProbe;
use App\Models\StationTracking;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Probe extends PpciLibrary
{
    /**
     * @var Models
     */
    protected PpciModel $dataclass;
    public StationTracking $stationTracking;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsProbe;
        $this->keyName = "probe_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        $this->stationTracking = new StationTracking;
    }

    function change()
    {
        if (!$this->stationTracking->verifyProject($_REQUEST["station_id"])) {
            $this->message->set(_("La station ne fait partie d'un projet autorisé"), true);
            return defaultPage();
        }
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "tracking/probeChange.tpl", $_REQUEST["station_id"]);
        $this->vue->set($this->stationTracking->lire($_REQUEST["station_id"]), "station");
        return $this->vue->send();
    }
    function write()
    {
        if (!$this->stationTracking->verifyProject($_REQUEST["station_id"])) {
            $this->message->set(_("La station ne fait partie d'un projet autorisé"), true);
            return false;
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
            return false;
        }
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        };
    }
}
