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
include_once 'modules/classes/operator.class.php';
$this->dataclass = new Operator;
$this->keyName = "operator_id";
$this->id = $_REQUEST[$this->keyName];



	function list()
{
$this->vue=service('Smarty');
		$this->vue->set($this->dataclass->getListe("name,firstname"), "data");
		$this->vue->set("param/operatorList.tpl", "corps");
		}
	function change()
{
$this->vue=service('Smarty');
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
		$this->dataRead( $this->id, "param/operatorChange.tpl");
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
