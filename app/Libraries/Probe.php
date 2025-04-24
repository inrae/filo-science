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
include_once 'modules/classes/tracking/probe.class.php';
include_once 'modules/classes/tracking/station_tracking.class.php';
$this->dataclass = new Probe;
$stationTracking = new StationTracking;
$this->keyName = "probe_id";
$this->id = $_REQUEST[$this->keyName];
if (!$stationTracking->verifyProject($_REQUEST["station_id"])) {
    $this->message->set(_("La station ne fait partie d'un projet autorisé"), true);
    $t_module["retourko"] = "default";
    return false;
} else {
    
        function change()
{
$this->vue=service('Smarty');
            $data = $this->dataRead( $this->id, "tracking/probeChange.tpl", $_REQUEST["station_id"]);
            $this->vue->set($stationTracking->lire($_REQUEST["station_id"]), "station");
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
           
            /**
             * write record in database
             */
            $this->id = $this->dataWrite($this->dataclass, $_REQUEST);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
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