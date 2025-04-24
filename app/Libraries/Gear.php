<?php

namespace App\Libraries;

use App\Models\Gear as ModelsGear;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Gear extends PpciLibrary
{
	/**
	 * @var ModelsGear
	 */
	protected PpciModel $dataclass;


	function __construct()
	{
		parent::__construct();
		$this->dataclass = new ModelsGear;
		$this->keyName = "gear_id";
		if (isset($_REQUEST[$this->keyName])) {
			$this->id = $_REQUEST[$this->keyName];
		}
	}

	function list()
	{
		$this->vue = service('Smarty');
		$this->vue->set($this->dataclass->getListe(1), "data");
		$this->vue->set("param/gearList.tpl", "corps");
		return $this->vue->send();
	}
	function change()
	{
		$this->vue = service('Smarty');
		$this->dataRead($this->id, "param/gearChange.tpl");
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
