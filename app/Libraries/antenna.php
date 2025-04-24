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
include_once 'modules/classes/tracking/antenna.class.php';
include_once 'modules/classes/tracking/station_tracking.class.php';
$this->dataclass = new Antenna;
$stationTracking = new StationTracking;
$keyName = "antenna_id";
$this->id = $_REQUEST[$keyName];
if (!$stationTracking->verifyProject($_REQUEST["station_id"])) {
    $this->message->set(_("La station ne fait partie d'un projet autorisé"), true);
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
} else {
    
        function change()
{
$this->vue=service('Smarty');
            $data = $this->dataRead( $this->id, "tracking/antennaChange.tpl", $_REQUEST["station_id"]);
            $this->vue->set($stationTracking->lire($_REQUEST["station_id"]), "station");
            include_once 'modules/classes/param.class.php';
            $technology = new Param($bdd, "technology_type");
            $this->vue->set($technology->getListe(1), "technologies");
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
