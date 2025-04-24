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
require_once 'modules/classes/operation.class.php';
$this->dataclass = new Operation;
$this->keyName = "operation_id";
if (empty($_REQUEST[$this->keyName]) && $t_module["param"] == "display"){
    if ($_COOKIE["operation_uid"] > 0 && $this->dataclass->isGranted($_SESSION["projects"], $_COOKIE["operation_uid"]) && $t_module["param"] == "display") {
        $this->id = $_COOKIE["operation_uid"];
    } else {
        $t_module["param"] = "error";
        $t_module["retourko"] = "default";
        return false;
        $this->message->set(_("L'identifiant de l'opération est manquant"), true);
    }
} else {
    $origine == "document" ? $this->id = $_REQUEST[$this->keyName] : $this->id = $_SESSION["ti_operation"]->getValue($_REQUEST[$this->keyName]);
}

$campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);
if (isset($_REQUEST["activeTab"])) {
    $activeTab = $_REQUEST["activeTab"];
}

    function display()
{
$this->vue=service('Smarty');
        $data = $_SESSION["ti_operation"]->translateRow($this->dataclass->getDetail($this->id));
        $this->vue->set($_SESSION["ti_campaign"]->translateRow($data), "data");
        $this->vue->set("gestion/operationDisplay.tpl", "corps");
        /**
         * lists of related data
         */
        require_once 'modules/classes/sequence.class.php';
        $sequence = new Sequence;
        $sequences = $sequence->getListFromOperation($this->id);
        $sequences = $_SESSION["ti_sequence"]->translateList($sequences);
        $sequences = $_SESSION["ti_operation"]->translateList($sequences);
        $this->vue->set($sequences, "sequences");
        /**
         * Ambience
         */
        require_once 'modules/classes/ambience.class.php';
        $ambience = new Ambience;
        $dataAmbience = $ambience->getFromOperation($this->id);
        if (!isset($dataAmbience["ambience_id"])) {
            $dataAmbience["ambience_id"] = 0;
            $dataAmbience["operation_id"] = $this->id;
        }
        $dataAmbience = $_SESSION["ti_operation"]->translateRow(
            $_SESSION["ti_ambience"]->translateRow(
                $dataAmbience
            )
        );
        if ($dataAmbience["ambience_id"] == "") {
            $dataAmbience["ambience_id"] = 0;
        }
        $this->vue->set($dataAmbience, "ambience");
        /**
         * Operators
         */
        require_once 'modules/classes/operator.class.php';
        $operator = new Operator;
        $this->vue->set($operator->getListFromOperation($this->id), "operators");
        /**
         * select the good tab for display
         */
        if (isset($activeTab)) {
            $this->vue->set($activeTab, "activeTab");
        }
        /**
         * Map
         */
        setParamMap($this->vue);
        /**
         * Documents
         */
        include_once 'modules/classes/document.class.php';
        $document = new Document;
        $this->vue->set($document->documentGetListFromParent("operation", $this->id), "dataDoc");
        $this->vue->set("operation", "moduleParent");
        $this->vue->set($this->id, "parent_id");
        }

    function change()
{
$this->vue=service('Smarty');
        /**
         * Get campaign item
         */
        require_once 'modules/classes/campaign.class.php';
        $campaign = new Campaign;
        $dcampaign = $campaign->getDetail($campaign_id);
        $data = $this->dataRead( $this->id, "gestion/operationChange.tpl", $campaign_id);
        if ($data["operation_id"] == 0) {
            $data["protocol_id"] = $dcampaign["protocol_default_id"];
        }
        $data = $_SESSION["ti_campaign"]->translateRow($data);
        $this->vue->set($_SESSION["ti_operation"]->translateRow($data), "data");
        /**
         * Preparation of the parameters tables
         */
        $params = array("water_regime", "fishing_strategy", "scale", "taxa_template", "protocol");
        foreach ($params as $tablename) {
            setParamToVue($this->vue, $tablename);
        }
        /**
         * Stations
         */
        require_once 'modules/classes/station.class.php';
        $station = new Station;
        $this->vue->set($station->getListFromProject($dcampaign["project_id"]), "stations");
        /**
         * Map
         */
        setParamMap($this->vue);
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
           
        /*
         * write record in database
         */
        /**
         * Test if the project is authorized
         */
        $data = $_SESSION["ti_campaign"]->getDbkeyFromRow($_REQUEST);
        $data = $_SESSION["ti_operation"]->getDbkeyFromRow($data);
        $this->id = $this->dataWrite($this->dataclass, $data);
        if ($this->id > 0) {
            $_REQUEST[$this->keyName] = $_SESSION["ti_operation"]->setValue($this->id);
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
    function operatorsChange() {
        /**
         * Add operators to the operation
         */
        require_once 'modules/classes/operator.class.php';
        $operator = new Operator;
        try {
            $db = $this->dataclass->db;
$db->transBegin();
            $operator->setOperatorsToOperation($this->id, $_POST["operators"], $_POST["operator_responsible"]);
            return true;
            $db->transCommit();
        } catch (ObjetBDDException $e) {
            if ($db->transEnabled) {
    $db->transRollback();
}
            $this->message->set(_("Problème rencontré lors de l'enregistrement des opérateurs"), true);
            $this->message->setSyslog($e->getMessage());
            return false;
        }
        }
        function duplicate() {
        try {
            $db = $this->dataclass->db;
$db->transBegin();
            $newid = $this->dataclass->duplicate($this->id);
            if ($newid > 0) {
                $_REQUEST[$this->keyName] = $_SESSION["ti_operation"]->setValue($newid);
            }
            return true;
            $db->transCommit();
        } catch (ObjetBDDException $e) {
            if ($db->transEnabled) {
    $db->transRollback();
}
            $this->message->set(_("Problème rencontré lors de la duplication de l'opération"), true);
            $this->message->setSyslog($e->getMessage());
            return false;
        }
}
