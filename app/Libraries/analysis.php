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
require_once 'modules/classes/analysis.class.php';
$this->dataclass = new Analysis;
$keyName = "analysis_id";
if (empty($_REQUEST[$keyName]) && ! $_REQUEST[$keyName] == 0 ) {
    $t_module["param"] = "error";
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
}
$this->id = $_SESSION["ti_analysis"]->getValue($_REQUEST[$keyName]);
if (empty($this->id) ) {
    $this->id = 0;
}

$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);


    function change()
{
$this->vue=service('Smarty');
        /*
     * open the form to modify the record
     * If is a new record, generate a new record with default value :
     * $_REQUEST["idParent"] contains the identifiant of the parent record
     */
        $data = $this->dataRead( $this->id, "gestion/analysisChange.tpl", $sequence_id);
        require_once "modules/classes/sequence.class.php";
        $sequence = new Sequence;
        $dataSequence = $_SESSION["ti_operation"]->translateRow(
            $_SESSION["ti_campaign"]->translateRow(
                $_SESSION["ti_sequence"]->translateRow(
                    $sequence->getDetail($sequence_id)
                )
            )
        );
        $this->vue->set(
            $dataSequence,
            "sequence"
        );
        if ($dataSequence["analysis_template_id"] > 0) {
            /**
             * Get the complementary analysis template
             */
            include_once "modules/classes/analysis_template.class.php";
            $at = new AnalysisTemplate;
            $dat = $at->lire($dataSequence["analysis_template_id"]);
            $this->vue->set($dat["analysis_template_schema"], "analysis_template_schema");
        }
        if ($data["analysis_id"] == 0) {
            /**
             * Create a new record
             */
            $data["analysis_date"] = $dataSequence["date_start"];
            $data["sequence_id"] = $sequence_id;
        }
        $this->vue->set(
            $_SESSION["ti_sequence"]->translateRow(
                $_SESSION["ti_analysis"]->translateRow(
                    $data
                )
            ),
            "data"
        );
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
        $data = $_REQUEST;
        $data["sequence_id"] = $sequence_id;
        $data ["analysis_id"] = $this->id;
        $this->id = dataWrite($this->dataclass, $data);
        if ($this->id > 0) {
            $_REQUEST[$keyName] = $this->id;
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
}
