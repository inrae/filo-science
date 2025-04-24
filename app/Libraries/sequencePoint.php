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
require_once 'modules/classes/sequence_point.class.php';
$this->dataclass = new SequencePoint;
$keyName = "sequence_point_id";
if (empty($_REQUEST[$keyName]) && ! $_REQUEST[$keyName] == 0){
    $t_module["param"] = "error";
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
}
$this->id = $_SESSION["ti_sequencePoint"]->getValue($_REQUEST[$keyName]);
$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);
if (empty($this->id) && ! $this->id == 0) {
    $t_module["param"] = "error";
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
}

    function change()
{
$this->vue=service('Smarty');
        $this->vue->set("gestion/sequencePointChange.tpl", "corps");
        $data = $this->dataclass->lire($this->id, true, $sequence_id);
        $data["sequence_id"] = $_SESSION["ti_sequence"]->setValue($sequence_id);
        $this->vue->set($data = $_SESSION["ti_sequencePoint"]->translateRow($data), "data");
        require_once 'modules/classes/sequence.class.php';
        $sequence = new Sequence;
        $dsequence = $sequence->getDetail($sequence_id);
        $dsequence = $_SESSION["ti_sequence"]->translateRow($dsequence);
        $dsequence = $_SESSION["ti_operation"]->translateRow($dsequence);
        $dsequence = $_SESSION["ti_campaign"]->translateRow($dsequence);
        $this->vue->set($dsequence, "sequence");
        /**
         * Preparation of the parameters tables
         */
        $params = array("localisation", "facies");
        foreach ($params as $tablename) {
            setParamToVue($this->vue, $tablename);
        }
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
        $data = $_SESSION["ti_sequence"]->getDbkeyFromRow($_REQUEST);
        $data = $_SESSION["ti_sequencePoint"]->getDbkeyFromRow($data);
        $data["sequence_point_id"] = $this->id;
        dataWrite($this->dataclass, $data);
        /**
         * Treatment of a new record
         */
        if ($module_coderetour == 1) {
            $_REQUEST[$keyName] = 0;
        }
        $activeTab = "tab-point";
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
        $activeTab = "tab-point";
        }
}
