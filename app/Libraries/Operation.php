<?php

namespace App\Libraries;

use App\Models\Ambience;
use App\Models\Campaign;
use App\Models\Document;
use App\Models\Operation as ModelsOperation;
use App\Models\Operator;
use App\Models\Sequence;
use App\Models\Station;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Operation extends PpciLibrary
{
    /**
     * @var ModelsOperation
     */
    protected PpciModel $dataclass;
    public int $campaign_id;
    private string $activeTab;
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsOperation;
        $this->keyName = "operation_id";
        if (isset($_REQUEST[$this->keyName])) {
            $_SESSION["origine"] == "document" ? $this->id = $_REQUEST[$this->keyName] : $this->id = $_SESSION["ti_operation"]->getValue($_REQUEST[$this->keyName]);
        }
        if (isset($_REQUEST["campaign_id"])) {
            $this->campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);
        }

        if (isset($_REQUEST["activeTab"])) {
            $this->activeTab = $_REQUEST["activeTab"];
        }
    }
    function display()
    {
        if (empty($_REQUEST[$this->keyName])) {
            if ($_COOKIE["operation_uid"] > 0 && $this->dataclass->isGranted($_SESSION["projects"], $_COOKIE["operation_uid"])) {
                $this->id = $_COOKIE["operation_uid"];
            } else {
                $this->message->set(_("L'identifiant de l'opération est manquant"), true);
                defaultPage();
            }
        }
        $this->vue = service('Smarty');
        $data = $_SESSION["ti_operation"]->translateRow($this->dataclass->getDetail($this->id));
        $this->vue->set($_SESSION["ti_campaign"]->translateRow($data), "data");
        $this->vue->set("gestion/operationDisplay.tpl", "corps");
        /**
         * lists of related data
         */
        $sequence = new Sequence;
        $sequences = $sequence->getListFromOperation($this->id);
        $sequences = $_SESSION["ti_sequence"]->translateList($sequences);
        $sequences = $_SESSION["ti_operation"]->translateList($sequences);
        $this->vue->set($sequences, "sequences");
        /**
         * Ambience
         */
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
        $operator = new Operator;
        $this->vue->set($operator->getListFromOperation($this->id), "operators");
        /**
         * select the good tab for display
         */
        if (isset($this->activeTab)) {
            $this->vue->set($this->activeTab, "activeTab");
        }
        /**
         * Map
         */
        setParamMap($this->vue);
        /**
         * Documents
         */
        $document = new Document;
        $this->vue->set($document->documentGetListFromParent("operation", $this->id), "dataDoc");
        $this->vue->set("operation", "moduleParent");
        $this->vue->set($this->id, "parent_id");
        return $this->vue->send();
    }

    function change()
    {
        $this->vue = service('Smarty');
        /**
         * Get campaign item
         */
        $campaign = new Campaign;
        $dcampaign = $campaign->getDetail($this->campaign_id);
        $data = $this->dataRead($this->id, "gestion/operationChange.tpl", $this->campaign_id);
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
        $station = new Station;
        $this->vue->set($station->getListFromProject($dcampaign["project_id"]), "stations");
        /**
         * Map
         */
        setParamMap($this->vue);
        return $this->vue->send();
    }
    function write()
    {
        try {

            $data = $_SESSION["ti_campaign"]->getDbkeyFromRow($_REQUEST);
            $data = $_SESSION["ti_operation"]->getDbkeyFromRow($data);
            $this->id = $this->dataWrite( $data);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $_SESSION["ti_operation"]->setValue($this->id);
            }
            return true;
        } catch (PpciException $e) {
            return false;
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
    function operatorsChange()
    {
        /**
         * Add operators to the operation
         */
        $operator = new Operator;
        $db = $this->dataclass->db;
        try {
            $db->transBegin();
            $operator->setOperatorsToOperation($this->id, $_POST["operators"], $_POST["operator_responsible"]);
            return true;
            $db->transCommit();
        } catch (PpciException $e) {
            if ($db->transEnabled) {
                $db->transRollback();
            }
            $this->message->set(_("Problème rencontré lors de l'enregistrement des opérateurs"), true);
            $this->message->setSyslog($e->getMessage());
            return false;
        }
    }
    function duplicate()
    {
        try {
            $db = $this->dataclass->db;
            $db->transBegin();
            $newid = $this->dataclass->duplicate($this->id);
            if ($newid > 0) {
                $_REQUEST[$this->keyName] = $_SESSION["ti_operation"]->setValue($newid);
            }
            return true;
            $db->transCommit();
        } catch (PpciException $e) {
            if ($db->transEnabled) {
                $db->transRollback();
            }
            $this->message->set(_("Problème rencontré lors de la duplication de l'opération"), true);
            $this->message->setSyslog($e->getMessage());
            return false;
        }
    }
}
