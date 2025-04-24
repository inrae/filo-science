<?php

namespace App\Libraries;

use App\Models\ImportColumn;
use App\Models\ImportDescription as ModelsImportDescription;
use App\Models\ImportFunction;
use App\Models\Param;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ImportDescription extends PpciLibrary
{
    /**
     * @var Models
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsImportDescription;
        $this->keyName = "import_description_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getListe(), "imports");
        $this->vue->set("import/importDescriptionList.tpl", "corps");
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set("import/importDescriptionDisplay.tpl", "corps");
        $importFunction = new ImportFunction;
        $this->vue->set($importFunction->getListFromParent($this->id), "functions");
        $importColumn = new ImportColumn;
        $this->vue->set($importColumn->getListFromParent($this->id, "column_order"), "columns");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "import/importDescriptionChange.tpl");
        $csv = new Param("csv_type");
        $this->vue->set($csv->getListe(1), "csvTypes");
        $import = new Param("import_type");
        $this->vue->set($import->getListe(1), "importTypes");
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
            $db = $this->dataclass->db;
            $db->transBegin();
            $this->dataDelete($this->id, true);
            $db->transCommit();
            return true;
        } catch (PpciException $e) {
            if ($db->transEnabled) {
                $db->transRollback();
            }
            return false;
        }
    }
    function duplicate()
    {
        try {
            $db = $this->dataclass->db;
            $db->transBegin();
            $newId = $this->dataclass->duplicate($this->id);
            if ($newId > 0) {
                $_REQUEST[$this->keyName] = $newId;
                return true;
                $db->transCommit();
                $this->message->set(_("Duplication effectuée"));
                return true;
            } else {
                if ($db->transEnabled) {
                    $db->transRollback();
                }
                return false;
            }
        } catch (PpciException $e) {
            $this->message->set(_("La duplication a échoué. Si le problème se reproduit, contactez l'administrateur de l'application"), true);
            $this->message->setSyslog($e->getMessage());
            if ($db->transEnabled) {
                $db->transRollback();
            }
            return false;
        }
    }
}
