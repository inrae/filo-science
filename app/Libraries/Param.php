<?php

namespace App\Libraries;

use App\Models\Param as ModelsParam;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Param extends PpciLibrary
{
	/**
	 * @var Models
	 */
	protected PpciModel $dataclass;
	private $description = "";
	private $tablename = "";

	function __construct($tablename, $description = "")
	{
		parent::__construct();
		$this->dataclass = new ModelsParam($tablename);
		$this->keyName = $tablename . "_id";
		if (isset($_REQUEST[$this->keyName])) {
			$this->id = $_REQUEST[$this->keyName];
		}
		$this->description = $description;
		$this->tablename = $tablename;
	}

	function generateSet($vue, $tablename, $description)
	{
		$vue->set($tablename . "_id", "fieldid");
		$vue->set($tablename . "_name", "fieldname");
		$vue->set(_($description), "tabledescription");
		$vue->set($tablename, "tablename");
	}


	function list()
	{
		$this->vue = service('Smarty');
		$this->vue->set($this->dataclass->getListe(1), "data");
		$this->vue->set("tracking/paramList.tpl", "corps");
		$this->generateSet($this->vue, $this->tablename, $this->description);
		return $this->vue->send();
	}
	function change()
	{
		$this->vue = service('Smarty');
		$this->dataRead($this->id, "tracking/paramChange.tpl");
		$this->generateSet($this->vue, $this->tablename, $this->description);
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
