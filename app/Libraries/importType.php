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
include_once 'modules/classes/import/import_type.class.php';
$this->dataclass = new ImportType;
$keyName = "import_type_id";
$this->id = $_REQUEST[$keyName];


    function list()
{
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getListe(), "imports");
        $this->vue->set("import/importTypeList.tpl", "corps");
        }
    function change()
{
$this->vue=service('Smarty');
        $this->dataRead( $this->id, "import/importTypeChange.tpl");

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
