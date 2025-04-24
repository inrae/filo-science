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
include_once 'modules/classes/taxon.class.php';
$this->dataclass = new Taxon;
$this->keyName = "taxon_id";
$this->id = $_REQUEST[$this->keyName];



	function list()
{
$this->vue=service('Smarty');
		$this->vue->set($this->dataclass->getListe(1), "data");
		$this->vue->set("param/taxonList.tpl", "corps");
		}
	function change()
{
$this->vue=service('Smarty');
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
		$this->dataRead( $this->id, "param/taxonChange.tpl");
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

	function searchAjax() {
		$this->vue->set($this->dataclass->search($_REQUEST["name"], $_REQUEST["freshwater"], $_REQUEST["noFreshcode"]));
		}

	function lireAjax() {
		$this->vue->set($this->dataclass->lire($_REQUEST["taxon_id"]));
		}
	function getListCode() {
		$this->vue->set($this->dataclass->getListCode($_REQUEST["freshwater"]));
		}
	function getFromCode() {
		$this->vue->set($this->dataclass->getFromCode($_REQUEST["code"], $_REQUEST["freshwater"]));
		}
}
