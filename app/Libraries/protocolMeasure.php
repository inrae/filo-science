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
include_once 'modules/classes/measure_template.class.php';
include_once 'modules/classes/protocol.class.php';
$this->dataclass = new Protocol;
$measureTemplate = new MeasureTemplate;
$keyName = "protocol_id";
$this->id = $_REQUEST[$keyName];


    function change()
{
$this->vue=service('Smarty');
        $this->dataRead( $this->id, "param/protocolMeasureChange.tpl");
        $this->vue->set($measureTemplate->getTotalListForProtocol($this->id), "measures");
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
        try {
            $db = $this->dataclass->db;
$db->transBegin();
            $this->dataclass->ecrireTableNN("protocol_measure", "protocol_id", "measure_template_id", $this->id, $_POST["measure_template_id"]);
            $db->transCommit();
            $module_coderetour = 1;
        } catch (Exception $e) {
            $this->message->set(_("Echec d'écriture de la liste des modèles de mesures rattachées au protocole"), true);
            $this->message->setSyslog($e->getMessage());
            $module_coderetour = -1;
            if ($db->transEnabled) {
    $db->transRollback();
}
        }
        }
}
