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
require_once 'modules/classes/tracking/transmitter_type.class.php';
$this->dataclass = new TransmitterType;
$keyName = "transmitter_type_id";
$this->id = $_REQUEST[$keyName];


    function list()
{
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getListe(), "data");
        $this->vue->set("tracking/transmitter_typeList.tpl", "corps");
        }
    function change()
{
$this->vue=service('Smarty');
        $this->dataRead( $this->id, "tracking/transmitter_typeChange.tpl");
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
