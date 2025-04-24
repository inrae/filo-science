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
include_once 'modules/classes/measure_template.class.php';
include_once 'modules/classes/protocol.class.php';
$this->dataclass = new Protocol;
$measureTemplate = new MeasureTemplate;
$this->keyName = "protocol_id";
$this->id = $_REQUEST[$this->keyName];


    function change()
{
$this->vue=service('Smarty');
        $this->dataRead( $this->id, "param/protocolMeasureChange.tpl");
        $this->vue->set($measureTemplate->getTotalListForProtocol($this->id), "measures");
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
           
        try {
            $db = $this->dataclass->db;
$db->transBegin();
            $this->dataclass->ecrireTableNN("protocol_measure", "protocol_id", "measure_template_id", $this->id, $_POST["measure_template_id"]);
            $db->transCommit();
            return true;
        } catch (Exception $e) {
            $this->message->set(_("Echec d'écriture de la liste des modèles de mesures rattachées au protocole"), true);
            $this->message->setSyslog($e->getMessage());
            return false;
            if ($db->transEnabled) {
    $db->transRollback();
}
        }
        }
}
