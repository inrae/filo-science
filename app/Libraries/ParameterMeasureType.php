<?php

namespace App\Libraries;

use App\Models\ParameterMeasureType as ModelsParameterMeasureType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ParameterMeasureType extends PpciLibrary
{
    /**
     * @var ModelsParameterMeasureType
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsParameterMeasureType;
        $this->keyName = "parameter_measure_type_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getListe(), "parameters");
        $this->vue->set("tracking/parameterMeasureTypeList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "tracking/parameterMeasureTypeChange.tpl");
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
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        };
    }
}
