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
include_once 'modules/classes/import/export_model.class.php';
$this->dataclass = new ExportModel;
$keyName = "export_model_id";
$this->id = $_REQUEST[$keyName];


    function list()
{
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getListe("export_model_name"), "data");
        $this->vue->set("import/exportModelList.tpl", "corps");
        }
    function display()
{
$this->vue=service('Smarty');
        $data = $this->dataclass->lire($this->id);
        $this->vue->set($data, "data");
        $this->vue->set(json_decode($data["pattern"], true), "pattern");
        $this->vue->set("import/exportModelDisplay.tpl", "corps");
        }
    function change()
{
$this->vue=service('Smarty');
        $this->dataRead( $this->id, "import/exportModelChange.tpl");
        }
    function duplicate() {
        $data = $this->dataclass->lire($this->id);
        $data["export_model_id"] = 0;
        $data["export_model_name"] .= " - copy";
        $this->vue->set($data, "data");
        $this->vue->set("import/exportModelChange.tpl", "corps");
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
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        };
        }
}
