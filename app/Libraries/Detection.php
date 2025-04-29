<?php

namespace App\Libraries;

use App\Models\Antenna;
use App\Models\Detection as ModelsDetection;
use App\Models\IndividualTracking;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Detection extends PpciLibrary
{
    /**
     * @var ModelsDetection
     */
    protected PpciModel $dataclass;
    public IndividualTracking $individualTracking;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsDetection;
        $this->keyName = "detection_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        helper("filo");
    }

    function change()
    {
        $this->vue = service('Smarty');
        if ($this->id == 0) {
            $individual_id = $_REQUEST["individual_id"];
            $data = $this->dataclass->getDefaultValues($individual_id);
        } else {
            $data = $this->dataclass->lire($this->id);
            $individual_id = $data["individual_id"];
        }
        $dindividual = $this->individualTracking->getDetail($individual_id);
        if (!verifyProject($dindividual["project_id"])) {
            return defaultPage();
        }
        $this->vue->set($data, "data");
        $this->vue->set("tracking/detectionChange.tpl", "corps");
        $this->vue->set($dindividual, "individual");
        /**
         * Get the list of antennas and locations
         */
        $antenna = new Antenna;
        $this->vue->set($antenna->getListFromProject($dindividual["project_id"]), "antennas");
        return $this->vue->send();
    }
    function write()
    {
        try {
            if ($this->id == 0) {
                $individual_id = $_REQUEST["individual_id"];
            } else {
                $data = $this->dataclass->lire($this->id);
                $individual_id = $data["individual_id"];
            }
            $dindividual = $this->individualTracking->getDetail($individual_id);
            if (!verifyProject($dindividual["project_id"])) {
                return defaultPage();
            }
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST[$this->keyName] = $this->id;
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }
    function delete()
    {
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
    function calculateSunPeriod()
    {
        $this->vue = service('Smarty');
        $this->vue->set("tracking/detectionRecalculate.tpl", "corps");
        $this->vue->set($_SESSION["projects"], "projects");
        return $this->vue->send();
    }
    function calculateSunPeriodExec()
    {
        if (verifyProject($_REQUEST["project_id"])) {
            try {
                $nb = $this->dataclass->calculateGlobalSunPeriod($_REQUEST["project_id"]);
                $this->message->set(sprintf(_("Recalcul effectué, %s détections traitées"), $nb));
                return true;
            } catch (PpciException $e) {
                $this->message->set(_("Une erreur est survenue pendant l'opération"), true);
                $this->message->set($e->getMessage());
                return false;
            }
        }
    }
}
