<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class  extends PpciLibrary { 
    /**
     * @var Models
*/
    protected PpciModel $dataclass;
    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ;
        $this->keyName = "";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
$tablename = $t_module["tablename"];
include_once 'modules/classes/tracking/param.class.php';
$this->dataclass = new Param( $tablename);
$keyName = $tablename . "_id";
$this->id = $_REQUEST[$this->keyName];
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
            
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST[$this->keyName] = $this->id;
            return true;
        } catch (PpciException $e) {
            return false;
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
