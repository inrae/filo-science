<?php

namespace App\Libraries;

use App\Models\ExportModel as ModelsExportModel;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ExportModel extends PpciLibrary
{
    /**
     * @var Models
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsExportModel;
        $this->keyName = "export_model_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getListe("export_model_name"), "data");
        $this->vue->set("import/exportModelList.tpl", "corps");
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $data = $this->dataclass->lire($this->id);
        $this->vue->set($data, "data");
        $this->vue->set(json_decode($data["pattern"], true), "pattern");
        $this->vue->set("import/exportModelDisplay.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "import/exportModelChange.tpl");
        return $this->vue->send();
    }
    function duplicate()
    {
        $this->vue = service('Smarty');
        $data = $this->dataclass->lire($this->id);
        $data["export_model_id"] = 0;
        $data["export_model_name"] .= " - copy";
        $this->vue->set($data, "data");
        $this->vue->set("import/exportModelChange.tpl", "corps");
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
