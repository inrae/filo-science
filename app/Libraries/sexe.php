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
include_once 'modules/classes/sexe.class.php';
$this->dataclass = new Sexe;
$keyName = "sexe_id";
$this->id = $_REQUEST[$keyName];



	function list()
{
$this->vue=service('Smarty');
		$this->vue->set($this->dataclass->getListe(1), "data");
		$this->vue->set("param/sexeList.tpl", "corps");
		}
	function change()
{
$this->vue=service('Smarty');
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
		$this->dataRead( $this->id, "param/sexeChange.tpl");
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
