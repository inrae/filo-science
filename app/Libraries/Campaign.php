<?php

namespace App\Libraries;

use App\Models\Campaign as ModelsCampaign;
use App\Models\Operation;
use App\Models\Project;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Campaign extends PpciLibrary
{
    /**
     * @var ModelsCampaign
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsCampaign;
        $this->keyName = "campaign_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_SESSION["ti_campaign"]->getValue($_REQUEST[$this->keyName]);
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
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
            $project = new Project;
            $projects = $project->getProjectsActive($params["is_active"], $_SESSION["projects"]);
            if (empty($params["project_id"])) {
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
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
        }
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        if (empty($_REQUEST[$this->keyName])) {
            if ($_COOKIE["campaign_uid"] > 0 && $this->dataclass->isGranted($_SESSION["projects"], $_COOKIE["campaign_uid"])) {
                $this->id = $_COOKIE["campaign_uid"];
            } else {
                return defaultPage();
            }
        }
        $this->vue->set($_SESSION["ti_campaign"]->translateRow($this->dataclass->getDetail($this->id)), "data");
        $this->vue->set("gestion/campaignDisplay.tpl", "corps");
        /**
         * Get list of operations
         */
        $operation = new Operation;
        $doperation = $_SESSION["ti_operation"]->translateList($operation->getListFromCampaign($this->id));
        $this->vue->set($_SESSION["ti_campaign"]->translateList($doperation), "operations");
        return $this->vue->send();
    }

    function change()
    {
        $this->vue = service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = $this->dataRead($this->id, "gestion/campaignChange.tpl");
        $this->vue->set($_SESSION["ti_campaign"]->translateRow($data), "data");
        $this->vue->set($_SESSION["projects"], "projects");
        return $this->vue->send();
    }
    function write()
    {
        try {
            if (verifyProject($_REQUEST["project_id"])) {

                $this->id = $this->dataWrite($_SESSION["ti_campaign"]->getDbkeyFromRow($_REQUEST));
                $_REQUEST[$this->keyName] = $_SESSION["ti_campaign"]->setValue($this->id);
                return true;
            } else {
                $this->message->set(_("Vous ne disposez pas des droits nécessaires pour le projet considéré pour réaliser cette opération"), true);
                return false;
            }
        } catch (PpciException $e) {
            return false;
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
            return false;
        }
    }
}
