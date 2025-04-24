<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $this->dataclass;
    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new XXX();
        $keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
include_once 'modules/classes/import/import_description.class.php';
$this->dataclass = new ImportDescription;
$keyName = "import_description_id";
$this->id = $_REQUEST[$keyName];


    function list()
{
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getListe(), "imports");
        $this->vue->set("import/importDescriptionList.tpl", "corps");
        }
    function display()
{
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set("import/importDescriptionDisplay.tpl", "corps");
        include_once "modules/classes/import/import_function.class.php";
        $importFunction = new ImportFunction;
        $this->vue->set($importFunction->getListFromParent($this->id), "functions");
        include_once "modules/classes/import/import_column.class.php";
        $importColumn = new ImportColumn;
        $this->vue->set($importColumn->getListFromParent($this->id, "column_order"), "columns");
        }
    function change()
{
$this->vue=service('Smarty');
        $this->dataRead( $this->id, "import/importDescriptionChange.tpl");
        include_once "modules/classes/param.class.php";
        $csv = new Param($bdd, "csv_type");
        $this->vue->set($csv->getListe(1), "csvTypes");
        $import = new Param($bdd, "import_type");
        $this->vue->set($import->getListe(1), "importTypes");
        }
    function write()
{
try {
            $this->id =         try {
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST["xx_id"] = $this->id;
            return true;
        } catch (PpciException $e) {
            return false;
        }
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
        } catch (PpciException) {
            return false;
        }
        $this->id = dataWrite($this->dataclass, $_REQUEST);
        if ($this->id > 0) {
            $_REQUEST[$keyName] = $this->id;
        }
        }
    function delete()
{
        try {
            $db = $this->dataclass->db;
$db->transBegin();
            $this->dataDelete( $this->id, true);
            $db->transCommit();
            $module_coderetour = 1;
        } catch (Exception $e) {
            if ($db->transEnabled) {
    $db->transRollback();
}
        }
        }
    function duplicate() {
        try {
            $db = $this->dataclass->db;
$db->transBegin();
            $newId = $this->dataclass->duplicate($this->id);
            if ($newId > 0) {
                $_REQUEST[$keyName] = $newId;
                $module_coderetour = 1;
                $db->transCommit();
                $this->message->set(_("Duplication effectuée"));
            } else {
                if ($db->transEnabled) {
    $db->transRollback();
}
                $module_coderetour = -1;
            }
        } catch (Exception $e) {
            $this->message->set(_("La duplication a échoué. Si le problème se reproduit, contactez l'administrateur de l'application"), true);
            $this->message->setSyslog($e->getMessage());
            if ($db->transEnabled) {
    $db->transRollback();
}
            $module_coderetour = -1;
        }
}
