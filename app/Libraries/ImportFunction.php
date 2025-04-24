<?php

namespace App\Libraries;

use App\Models\FunctionType;
use App\Models\ImportFunction as ModelsImportFunction;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ImportFunction extends PpciLibrary
{
    /**
     * @var ModelsImportFunction
     */
    protected PpciModel $dataclass;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsImportFunction;
        $this->keyName = "import_function_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "import/importFunctionChange.tpl", $_REQUEST["import_description_id"]);
        $functionType = new FunctionType;
        $this->vue->set($functionType->getListe("function_name"), "functions");
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
    function getFunctionDescription()
    {
        $this->vue=service('Smarty');
        $functionType = new FunctionType;
        $this->vue->set($functionType->getDescription($_REQUEST["function_type_id"]));
        return $this->vue->send();
    }
}
