<?php

namespace App\Libraries;

use App\Models\Ambience as ModelsAmbience;
use App\Models\AmbienceTemplate;
use App\Models\Operation;
use App\Models\Sequence;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Ambience extends PpciLibrary
{
	/**
	 * @var ModelsAmbience
	 */
	protected PpciModel $dataclass;
	public $operation_id;
	public $sequence_id;
	function __construct()
	{
		parent::__construct();
		$this->dataclass = new ModelsAmbience;
		$this->keyName = "ambience_id";
		if (isset($_REQUEST[$this->keyName])) {
			$this->id = $_SESSION["ti_ambience"]->getValue($_REQUEST[$this->keyName]);
			$this->operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
			$this->sequence_id = $_SESSION["ti_sequence"]->getValue($_REQUEST["sequence_id"]);
		}
	}

	function change()
	{
		$this->vue = service('Smarty');
		$data = $this->dataRead($this->id, "gestion/ambienceChange.tpl");
		/**
		 * Set origin
		 */
		$this->vue->set($_REQUEST["origin"], "origin");
		/**
		 * Get sequence or operation data
		 */
		if ($_REQUEST["origin"] == "operation") {
			$op = new Operation;
			$dparent = $_SESSION["ti_operation"]->translateRow(
				$_SESSION["ti_campaign"]->translateRow(
					$op->getDetail($this->operation_id)
				)
			);
		} else {
			$seq = new Sequence;
			$dparent = $_SESSION["ti_operation"]->translateRow(
				$_SESSION["ti_campaign"]->translateRow(
					$_SESSION["ti_sequence"]->translateRow(
						$seq->getDetail($this->sequence_id)
					)
				)
			);
		}
		$this->vue->set($dparent, "dataParent");
		if ($dparent["ambience_template_id"] > 0) {
			/**
			 * Get the complementary measures template
			 */
			$at = new AmbienceTemplate;
			$dat = $at->lire($dparent["ambience_template_id"]);
			$this->vue->set($dat["ambience_template_schema"], "ambience_template_schema");
		}
		if ($this->id == 0) {
			$data["operation_id"] = $this->operation_id;
			$data["sequence_id"] = $this->sequence_id;
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
		$tables = array("granulometry", "speed", "shady", "clogging", "facies", "sinuosity", "localisation", "turbidity", "situation", "flow_trend", "vegetation", "cache_abundance");
		helper("filo");
		foreach ($tables as $tablename) {
			setParamToVue($this->vue, $tablename);
		}
		/**
		 * Map
		 */
		helper("filo");
		setParamMap($this->vue, true);
		return $this->vue->send();
	}
	function write()
	{
		try {
			$data = $_REQUEST;
			$data["ambience_id"] = $this->id;
			if ($this->operation_id > 0) {
				$data["operation_id"] = $this->operation_id;
			} else {
				unset($data["operation_id"]);
			}
			if ($this->sequence_id > 0) {
				$data["sequence_id"] = $this->sequence_id;
			} else {
				unset($data["sequence_id"]);
				$this->id = $this->dataWrite($data);
				$_REQUEST[$this->keyName] = $this->id;
				if ($this->id > 0) {
					$_REQUEST[$this->keyName] = $_SESSION["ti_ambience"]->setValue($this->id);
				}
				return true;
			}
		} catch (PpciException) {
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
		} catch (PpciException) {
			return false;
		};
	}
}
