<?php

namespace App\Libraries;

use App\Models\Sequence;
use App\Models\SequencePoint as ModelsSequencePoint;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class SequencePoint extends PpciLibrary
{
    /**
     * @var ModelsSequencePoint
     */
    protected PpciModel $dataclass;
    private int $sequence_id;
    private $activeTab;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsSequencePoint;
        $this->keyName = "sequence_point_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_SESSION["ti_sequencePoint"]->getValue($_REQUEST[$this->keyName]);
        }
        $this->sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);
    }

    function change()
    {
        $this->vue = service('Smarty');
        $this->vue->set("gestion/sequencePointChange.tpl", "corps");
        $data = $this->dataclass->lire($this->id, true, $this->sequence_id);
        $data["sequence_id"] = $_SESSION["ti_sequence"]->setValue($this->sequence_id);
        $this->vue->set($data = $_SESSION["ti_sequencePoint"]->translateRow($data), "data");
        $sequence = new Sequence;
        $dsequence = $sequence->getDetail($this->sequence_id);
        $dsequence = $_SESSION["ti_sequence"]->translateRow($dsequence);
        $dsequence = $_SESSION["ti_operation"]->translateRow($dsequence);
        $dsequence = $_SESSION["ti_campaign"]->translateRow($dsequence);
        $this->vue->set($dsequence, "sequence");
        /**
         * Preparation of the parameters tables
         */
        $params = array("localisation", "facies");
        foreach ($params as $tablename) {
            setParamToVue($this->vue, $tablename);
        }
        if (!empty($this->activeTab)) {
            $this->vue->set($this->activeTab, "activeTab");
        }
        return $this->vue->send();
    }
    function write()
    {
        try {
            $data = $_SESSION["ti_sequence"]->getDbkeyFromRow($_REQUEST);
            $data = $_SESSION["ti_sequencePoint"]->getDbkeyFromRow($data);
            $data["sequence_point_id"] = $this->id;
            $this->dataWrite($data);
            /**
             * Treatment of a new record
             */
            $_REQUEST[$this->keyName] = 0;
            $this->activeTab = "tab-point";
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
            $this->activeTab = "tab-point";
            return true;
        } catch (PpciException $e) {
            return false;
        };
    }
}
