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
include_once 'modules/classes/import/import_column.class.php';
$this->dataclass = new ImportColumn;
$keyName = "import_column_id";
$this->id = $_REQUEST[$keyName];


    function change()
{
$this->vue=service('Smarty');
        $data = $this->dataRead( $this->id, "import/importColumnChange.tpl", $_REQUEST["import_description_id"]);
        /**
         * Get the list of columns usable during the import
         */
        include_once "modules/classes/import/import_description.class.php";
        $importDescription = new ImportDescription;
        $dDesc = $importDescription->getDetail($_REQUEST["import_description_id"]);
        $this->vue->set(explode(",", $dDesc["column_list"]),"columns");
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
