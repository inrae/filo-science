<?php

namespace App\Libraries;

use App\Models\IndividualTracking;
use App\Models\Location as ModelsLocation;
use App\Models\Param;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Location extends PpciLibrary
{
    /**
     * @var ModelsLocation
     */
    protected PpciModel $dataclass;
    public IndividualTracking $individualTracking;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsLocation;
        $this->keyName = "location_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        $this->dataclass->autoFormatDate = false;
        $this->individualTracking = new IndividualTracking;
    }

    function change()
    {
        /**
         * Verifiy the project
         */
        if ($this->id > 0) {
            $data = $this->dataclass->lire($this->id);
            $individual_id = $data["individual_id"];
        } else {
            $individual_id = $_REQUEST["individual_id"];
        }
        $dindividual = $this->individualTracking->getDetail($individual_id);
        if (!verifyProject($dindividual["project_id"])) {
            return defaultPage();
        }
        $this->vue = service('Smarty');
        if ($this->id == 0) {
            $data = $this->dataclass->getDefaultValue($individual_id);
        }
        $this->vue->set($data, "data");
        $this->vue->set("tracking/locationChange.tpl", "corps");
        $this->vue->set($dindividual, "individual");
        $param = new Param("antenna_type");
        $this->vue->set($param->getListe("antenna_type_name"), "antennas");
        setParamMap($this->vue, true);
        return $this->vue->send();
    }
    function write()
    {
        /**
         * Verifiy the project
         */
        if ($this->id > 0) {
            $data = $this->dataclass->lire($this->id);
            $individual_id = $data["individual_id"];
        } else {
            $individual_id = $_REQUEST["individual_id"];
        }
        $dindividual = $this->individualTracking->getDetail($individual_id);
        if (!verifyProject($dindividual["project_id"])) {
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
