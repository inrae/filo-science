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
include_once 'modules/classes/tracking/detection.class.php';
$this->dataclass = new Detection;
$this->dataclass->auto_date = 0;
include_once "modules/classes/tracking/individual_tracking.class.php";
$individualTracking = new IndividualTracking;

$keyName = "detection_id";
$this->id = $_REQUEST[$keyName];
/**
 * Verifiy the project
 */
if ($t_module["param"] != "calculateSunPeriod" && $t_module["param"] != "calculateSunPeriodExec") {
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
}
if ($module_coderetour != -1) {
  
    function change()
{
$this->vue=service('Smarty');
      if ($this->id == 0) {
        $data = $this->dataclass->getDefaultValue($individual_id);
      }
      $this->vue->set($data, "data");
      $this->vue->set("tracking/detectionChange.tpl", "corps");
      $this->vue->set($dindividual, "individual");
      /**
       * Get the list of antennas and locations
       */
      include_once "modules/classes/tracking/antenna.class.php";
      $antenna = new Antenna;
      $this->vue->set($antenna->getListFromProject($dindividual["project_id"]), "antennas");
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
    function calculateSunPeriod() {
      $this->vue->set("tracking/detectionRecalculate.tpl", "corps");
      $this->vue->set($_SESSION["projects"], "projects");
      }
    function calculateSunPeriodExec() {
      if (verifyProject($_REQUEST["project_id"])) {
        try {
          $nb = $this->dataclass->calculateGlobalSunPeriod($_REQUEST["project_id"]);
          $this->message->set(sprintf(_("Recalcul effectué, %s détections traitées"), $nb));
          $module_coderetour = 1;
        } catch (Exception $e) {
          $this->message->set(_("Une erreur est survenue pendant l'opération"), true);
          $this->message->set($e->getMessage());
          $module_coderetour = -1;
        }
      }
      }
  }
}
