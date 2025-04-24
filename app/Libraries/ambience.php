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
require_once 'modules/classes/ambience.class.php';
$this->dataclass = new Ambience;
$keyName = "ambience_id";
if (empty($_REQUEST[$keyName]) && !$_REQUEST[$keyName] == 0) {
	$t_module["param"] = "error";
	$t_module["retourko"] = "default";
	$module_coderetour = -1;
}
$this->id = $_SESSION["ti_ambience"]->getValue($_REQUEST[$keyName]);
$operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
$sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);


	function change()
{
$this->vue=service('Smarty');
		$data = $this->dataRead( $this->id, "gestion/ambienceChange.tpl");
		/**
		 * Set origin
		 */
		$this->vue->set($_REQUEST["origin"], "origin");
		/**
		 * Get sequence or operation data
		 */
		if ($_REQUEST["origin"] == "operation") {
			require_once 'modules/classes/operation.class.php';
			$op = new Operation;
			$dparent = $_SESSION["ti_operation"]->translateRow(
				$_SESSION["ti_campaign"]->translateRow(
					$op->getDetail($operation_id)
				)
			);
		} else {
			require_once 'modules/classes/sequence.class.php';
			$seq = new Sequence;
			$dparent = $_SESSION["ti_operation"]->translateRow(
				$_SESSION["ti_campaign"]->translateRow(
					$_SESSION["ti_sequence"]->translateRow(
						$seq->getDetail($sequence_id)
					)
				)
			);
		}
		$this->vue->set($dparent, "dataParent");
		if ($dparent["ambience_template_id"] > 0) {
			/**
			 * Get the complementary measures template
			 */
			include_once "modules/classes/ambience_template.class.php";
			$at = new AmbienceTemplate;
			$dat = $at->lire($dparent["ambience_template_id"]);
			$this->vue->set($dat["ambience_template_schema"], "ambience_template_schema");
		}
		if ($this->id == 0) {
			$data["operation_id"] = $operation_id;
			$data["sequence_id"] = $sequence_id;
			$data["ambience_long"] = $dparent["long_start"];
			$data["ambience_lat"] = $dparent["lat_start"];
		}
		$this->vue->set(
			$_SESSION["ti_ambience"]->translateRow(
				$_SESSION["ti_operation"]->translateRow(
					$_SESSION["ti_sequence"]->translateRow(
						$data
					)
				)
			),
			"data"
		);
		/**
		 * Treatment of parameters
		 */
		require_once 'modules/classes/param.class.php';
		$tables = array("granulometry", "speed", "shady", "clogging", "facies", "sinuosity", "localisation", "turbidity", "situation", "flow_trend", "vegetation", "cache_abundance");
		foreach ($tables as $tablename) {
			setParamToVue($this->vue, $tablename);
		}
		/**
		 * Map
		 */
		setParamMap($this->vue, true);
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
		$data = $_REQUEST;
		$data["ambience_id"] = $this->id;
		if ($operation_id > 0) {
			$data["operation_id"] = $operation_id;
		} else {
			unset($data["operation_id"]);
		}
		if ($sequence_id > 0) {
			$data["sequence_id"] = $sequence_id;
		} else {
			unset($data["sequence_id"]);
		}
		$this->id = dataWrite($this->dataclass, $data);


		if ($this->id > 0) {
			$_REQUEST[$keyName] = $_SESSION["ti_ambience"]->setValue($this->id);
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
