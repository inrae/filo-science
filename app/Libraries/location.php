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
include_once 'modules/classes/tracking/location.class.php';
$this->dataclass = new Location;
$this->dataclass->auto_date = 0;
include_once "modules/classes/tracking/individual_tracking.class.php";
$individualTracking = new IndividualTracking;

$keyName = "location_id";
$this->id = $_REQUEST[$keyName];
/**
 * Verifiy the project
 */
if ($this->id > 0) {
    $data = $this->dataclass->lire($this->id);
    $individual_id = $data["individual_id"];
} else {
    $individual_id = $_REQUEST["individual_id"];
}
$dindividual = $individualTracking->getDetail($individual_id);
if (!verifyProject($dindividual["project_id"])) {
    $module_coderetour = -1;
}

if ($module_coderetour != -1) {
    
        function change()
{
$this->vue=service('Smarty');
            if ($this->id == 0) {
                $data = $this->dataclass->getDefaultValue($individual_id);
            }
            $this->vue->set($data, "data");
            $this->vue->set("tracking/locationChange.tpl", "corps");
            $this->vue->set($dindividual, "individual");
            include_once "modules/classes/param.class.php";
            $param = new Param($bdd, "antenna_type");
            $this->vue->set($param->getListe("antenna_type_name"), "antennas");
            setParamMap($this->vue, true);
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
            /**
             * write record in database
             */
            $this->id = dataWrite($this->dataclass, $_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$keyName] = $this->id;
            }
            }
        function delete()
{
            /**
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
}