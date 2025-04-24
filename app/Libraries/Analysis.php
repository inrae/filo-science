<?php

namespace App\Libraries;

use App\Models\Analysis as ModelsAnalysis;
use App\Models\AnalysisTemplate;
use App\Models\Sequence;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Analysis extends PpciLibrary
{
    /**
     * @var ModelsAnalysis
     */
    protected PpciModel $dataclass;
    public $sequence_id;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsAnalysis;
        $this->keyName = "analysis_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_SESSION["ti_analysis"]->getValue($_REQUEST[$this->keyName]);
        }
        if (empty($this->id)) {
            $this->id = 0;
        }
        $this->sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);
    }

    function change()
    {
        $this->vue = service('Smarty');
        /*
     * open the form to modify the record
     * If is a new record, generate a new record with default value :
     * $_REQUEST["idParent"] contains the identifiant of the parent record
     */
        $data = $this->dataRead($this->id, "gestion/analysisChange.tpl", $this->sequence_id);
        $sequence = new Sequence;
        $dataSequence = $_SESSION["ti_operation"]->translateRow(
            $_SESSION["ti_campaign"]->translateRow(
                $_SESSION["ti_sequence"]->translateRow(
                    $sequence->getDetail($this->sequence_id)
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
            $at = new AnalysisTemplate;
            $dat = $at->lire($dataSequence["analysis_template_id"]);
            $this->vue->set($dat["analysis_template_schema"], "analysis_template_schema");
        }
        if ($data["analysis_id"] == 0) {
            /**
             * Create a new record
             */
            $data["analysis_date"] = $dataSequence["date_start"];
            $data["sequence_id"] = $this->sequence_id;
        }
        $this->vue->set(
            $_SESSION["ti_sequence"]->translateRow(
                $_SESSION["ti_analysis"]->translateRow(
                    $data
                )
            ),
            "data"
        );
        return $this->vue->send();
    }
    function write()
    {
        try {
            $data = $_REQUEST;
            $data["sequence_id"] = $this->sequence_id;
            $data["analysis_id"] = $this->id;
            $this->id = $this->dataWrite($data);
            $_REQUEST[$this->keyName] = $this->id;
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
}
