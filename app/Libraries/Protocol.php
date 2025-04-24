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
include_once 'modules/classes/protocol.class.php';
$this->dataclass = new Protocol;
$this->keyName = "protocol_id";
$this->id = $_REQUEST[$this->keyName];



    function list()
{
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getListProtocol(), "data");
        $this->vue->set("param/protocolList.tpl", "corps");
        }
    function change()
{
$this->vue=service('Smarty');
        $this->dataRead( $this->id, "param/protocolChange.tpl");
        require_once "modules/classes/analysis_template.class.php";
        $at = new AnalysisTemplate;
        $this->vue->set($at->getListe(1), "dataat");
        require_once "modules/classes/ambience_template.class.php";
        $ambienceTemplate = new AmbienceTemplate;
        $this->vue->set($ambienceTemplate->getListe(1), "ambiences");
        }
    function display()
{
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set("param/protocolDisplay.tpl", "corps");
        /**
         * Get the associated documents
         */
        include_once 'modules/classes/document.class.php';
        $document = new Document;
        $this->vue->set($document->getListFromParent("protocol", $this->id), "dataDoc");
        $this->vue->set("protocol", "moduleParent");
        $this->vue->set($this->id, "parent_id");

        /**
         * List of measures templates
         */
        include_once 'modules/classes/measure_template.class.php';
        $mt = new MeasureTemplate;
        $this->vue->set($mt->getListFromProtocol($this->id), "mtdata");
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
    function getTaxonTemplate() {
        if ($this->id > 0 && $_REQUEST["taxon_id"] > 0) {
            $this->vue->setJson($this->dataclass->getTaxonTemplate($this->id, $_REQUEST["taxon_id"]));
        }
        }
}
