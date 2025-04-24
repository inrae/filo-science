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
require_once 'modules/classes/campaign.class.php';
$this->dataclass = new Campaign;
$keyName = "campaign_id";
if (empty($_REQUEST[$keyName])&& $t_module["param"] == "display") {
    if ($_COOKIE["campaign_uid"] > 0 && $this->dataclass->isGranted($_SESSION["projects"], $_COOKIE["campaign_uid"]) ) {
        $this->id = $_COOKIE["campaign_uid"];
    } else {
        $t_module["param"] = "error";
        $t_module["retourko"] = "default";
        $module_coderetour = -1;
    }
} else {
    $this->id = $_SESSION["ti_campaign"]->getValue($_REQUEST[$keyName]);
}



    function list()
{
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        try {
            /**
             * Search parameters
             */
            $params = $_REQUEST;
            if (!isset($params["is_active"])) {
                $params["is_active"] = 1;
            }
            include_once "modules/classes/project.class.php";
            $project = new Project;
            $projects = $project->getProjectsActive($params["is_active"], $_SESSION["projects"]);
            if (empty($params["project_id"]) ) {
                $params["project_id"] = $projects[0]["project_id"];
            }
            $_SESSION["searchCampaign"]->setParam($params);
            $dataSearch = $_SESSION["searchCampaign"]->getParam();

            $data = $this->dataclass->getListSearch($dataSearch);
            $this->vue->set($_SESSION["ti_campaign"]->translateList($data), "data");
            $this->vue->set(1, "isSearch");


            $this->vue->set($projects, "projects");
            $this->vue->set($dataSearch, "searchCampaign");
            $this->vue->set("gestion/campaignList.tpl", "corps");
        } catch (Exception $e) {
            $this->message->set($e->getMessage(), true);
        }
        }
    function display()
{
$this->vue=service('Smarty');
        $this->vue->set($_SESSION["ti_campaign"]->translateRow($this->dataclass->getDetail($this->id)), "data");
        $this->vue->set("gestion/campaignDisplay.tpl", "corps");
        /**
         * Get list of operations
         */
        require_once 'modules/classes/operation.class.php';
        $operation = new Operation;
        $doperation = $_SESSION["ti_operation"]->translateList($operation->getListFromCampaign($this->id));
        $this->vue->set($_SESSION["ti_campaign"]->translateList($doperation), "operations");

        }

    function change()
{
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = $this->dataRead( $this->id, "gestion/campaignChange.tpl");
        $this->vue->set($_SESSION["ti_campaign"]->translateRow($data), "data");
        $this->vue->set($_SESSION["projects"], "projects");
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
        /**
         * Test if the project is authorized
         */
        if (verifyProject($_REQUEST["project_id"])) {
            $this->id = dataWrite($this->dataclass, $_SESSION["ti_campaign"]->getDbkeyFromRow($_REQUEST));
            if ($this->id > 0) {
                $_REQUEST[$keyName] = $_SESSION["ti_campaign"]->setValue($this->id);
            }
        } else {
            $this->message->set(_("Vous ne disposez pas des droits nécessaires pour le projet considéré pour réaliser cette opération"), true);
            $module_coderetour = -1;
        }
        }
    function delete()
{
        /*
         * delete record
         */
        if (verifyProject($_REQUEST["project_id"])) {
                    try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        };
        } else {
            $this->message->set(_("Vous ne disposez pas des droits nécessaires pour le projet considéré pour réaliser cette opération"), true);
            $module_coderetour = -1;
        }
        }
}
