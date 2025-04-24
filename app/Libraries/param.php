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
$tablename = $t_module["tablename"];
include_once 'modules/classes/tracking/param.class.php';
$this->dataclass = new Param($bdd, $tablename);
$keyName = $tablename . "_id";
$this->id = $_REQUEST[$keyName];
$description = $t_module["tabledescription"];

if (!function_exists("generateSet")) {
	function generateSet($this->vue, $tablename, $description)
	{
		$this->vue->set($tablename . "_id", "fieldid");
		$this->vue->set($tablename . "_name", "fieldname");
		$this->vue->set(_($description), "tabledescription");
		$this->vue->set($tablename, "tablename");
	}
}


	function list()
{
$this->vue=service('Smarty');
		$this->vue->set($this->dataclass->getListe(1), "data");
		$this->vue->set("tracking/paramList.tpl", "corps");
		generateSet($this->vue, $tablename, $description);
		}
	function display()
{
$this->vue=service('Smarty');

		}
	function change()
{
$this->vue=service('Smarty');
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
		$this->dataRead( $this->id, "tracking/paramChange.tpl");
		generateSet($this->vue, $tablename, $description);
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
		/*
		 * write record in database
		 */
		$this->id = dataWrite($this->dataclass, $_REQUEST);
		if ($this->id > 0) {
			$_REQUEST[$keyName] = $this->id;
		}
		}
	function delete()
{
		/*
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
