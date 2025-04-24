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
require_once 'modules/classes/tracking/transmitter_type.class.php';
$this->dataclass = new TransmitterType;
$this->keyName = "transmitter_type_id";
$this->id = $_REQUEST[$this->keyName];


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
            
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST[$this->keyName] = $this->id;
            return true;
        } catch (PpciException $e) {
            return false;
        }
           
        /**
         * write record in database
         */
        
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
