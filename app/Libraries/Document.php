<?php 
namespace App\Libraries;

use App\Models\Document as ModelsDocument;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Document extends PpciLibrary { 
    /**
     * @var ModelsDocument
*/
    protected PpciModel $dataclass;
    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsDocument;
        $this->keyName = "document_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function change()
{
$this->vue=service('Smarty');
        $this->dataRead( $this->id, "gestion/documentChange.tpl");
        return $this->vue->send();
        }
    function write()
{
try {
           
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
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
        }
        $origine = "document";
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
            return false;
        }
        }
}
