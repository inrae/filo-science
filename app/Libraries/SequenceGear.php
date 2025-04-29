<?php

namespace App\Libraries;

use App\Models\Sequence;
use App\Models\SequenceGear as ModelsSequenceGear;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class SequenceGear extends PpciLibrary
{
    /**
     * @var ModelsSequenceGear
     */
    protected PpciModel $dataclass;
    private int $sequence_id;
    private $activeTab;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsSequenceGear;
        $this->keyName = "sequence_gear_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_SESSION["ti_sequenceGear"]->getValue($_REQUEST[$this->keyName]);
            $this->id = $_REQUEST[$this->keyName];
        }
        $this->sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);
    }

    function change()
    {
        $this->vue = service('Smarty');

        $data = $this->dataRead($this->id, "gestion/sequenceGearChange.tpl", $this->sequence_id);
        $data["sequence_id"] = $_SESSION["ti_sequence"]->setValue($this->sequence_id);
        $this->vue->set($data = $_SESSION["ti_sequenceGear"]->translateRow($data), "data");
        $sequence = new Sequence;
        $dsequence = $sequence->getDetail($this->sequence_id);
        $dsequence = $_SESSION["ti_sequence"]->translateRow($dsequence);
        $dsequence = $_SESSION["ti_operation"]->translateRow($dsequence);
        $dsequence = $_SESSION["ti_campaign"]->translateRow($dsequence);
        $this->vue->set($dsequence, "sequence");
        /**
         * Preparation of the parameters tables
         */
        $params = array("electric_current_type", "gear_method", "gear");
        helper("filo");
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
            $data = $_SESSION["ti_sequenceGear"]->getDbkeyFromRow($data);
            $data["sequence_gear_id"] = $this->id;
            $this->id = $this->dataWrite($data);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $_SESSION["ti_sequenceGear"]->setValue($this->id);
            }
            $this->activeTab = "tab-gear";
            return true;
        } catch (PpciException $e) {
            return false;
        }

        /*
         * write record in database
         */
    }
    function delete()
    {
        try {
            $this->dataDelete($this->id);
            $this->activeTab = "tab-gear";
            return true;
        } catch (PpciException $e) {
            return false;
        };
    }
}
