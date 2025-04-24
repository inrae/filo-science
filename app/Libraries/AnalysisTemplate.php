<?php

namespace App\Libraries;

use App\Models\AnalysisTemplate as ModelsAnalysisTemplate;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class AnalysisTemplate extends PpciLibrary
{
	/**
	 * @var ModelsAnalysisTemplate
	 */
	protected PpciModel $dataclass;


	function __construct()
	{
		parent::__construct();
		$this->dataclass = new ModelsAnalysisTemplate;
		$this->keyName = "analysis_template_id";
		if (isset($_REQUEST[$this->keyName])) {
			$this->id = $_REQUEST[$this->keyName];
		}
	}

	function list()
	{
		$this->vue = service('Smarty');
		$this->vue->set($this->dataclass->getListe(1), "data");
		$this->vue->set("param/analysisTemplateList.tpl", "corps");
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
		$this->dataRead($this->id, "param/analysisTemplateChange.tpl");
		return $this->vue->send();
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
