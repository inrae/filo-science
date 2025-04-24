<?php

namespace App\Libraries;

use App\Models\ImportType as ModelsImportType;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ImportType extends PpciLibrary
{
    /**
     * @var Models
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsImportType;
        $this->keyName = "import_type_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getListe(), "imports");
        $this->vue->set("import/importTypeList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "import/importTypeChange.tpl");
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
