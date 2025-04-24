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
include_once 'modules/classes/document.class.php';
$this->dataclass = new Document;
$keyName = "document_id";
$this->id = $_REQUEST[$keyName];


    function change()
{
$this->vue=service('Smarty');
        /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 * moduleParent : nom du module a rappeler apres enregistrement
		 * parentType : nom de la table à laquelle sont rattaches les documents
		 * parentIdName : nom de la cle de la table parente
		 * parent_id : cle de la table parente
		 */
        $this->dataRead( $this->id, "gestion/documentChange.tpl");
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
        /*
			 * Preparation de files
			 */
        $files = array();
        $fdata = $_FILES['documentName'];
        if (is_array($fdata['name'])) {
            for ($i = 0; $i < count($fdata['name']); ++$i) {
                $files[] = array(
                    'name' => $fdata['name'][$i],
                    'type' => $fdata['type'][$i],
                    'tmp_name' => $fdata['tmp_name'][$i],
                    'error' => $fdata['error'][$i],
                    'size' => $fdata['size'][$i]
                );
            }
        } else {
            $files[] = $fdata;
        }
        foreach ($files as $file) {
            $this->id = $this->dataclass->documentEcrire($file, $_REQUEST["parent_table"], $_REQUEST["parent_id"], $_REQUEST["document_description"], $_REQUEST["document_creation_date"]);
            if ($this->id > 0) {
                $_REQUEST[$keyName] = $this->id;
                $module_coderetour = 1;
            } else {
                $module_coderetour = -1;
            }
        }
        $origine = "document";
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
        $origine = "document";
        }
    function get() {
        /*
		 * Envoi du document au navigateur
		 * Generation du nom du document
		 */
        $tmp_name = $this->dataclass->prepareDocument($this->id, $_REQUEST["phototype"]);
        if (!empty($tmp_name) && is_file($tmp_name)) {
            /*
			 * Recuperation du type mime
			 */
            $data = $this->dataclass->getData($this->id);
            $param = array("tmp_name" => $tmp_name, "content_type" => $data["content_type"]);
            if ($_REQUEST["attached"] == 1) {
                $param["disposition"] = "attachment";
                $fn = explode('/', $tmp_name);
                $param["filename"] = $fn[count($fn) - 1];
            } else {
                $param["disposition"] = "inline";
            }
            $this->vue->setParam($param);
        } else {
            unset($this->vue);
            $module_coderetour = -1;
        }
        }
}
