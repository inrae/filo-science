<?php

namespace App\Libraries;

use App\Models\Taxon as ModelsTaxon;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Taxon extends PpciLibrary
{
	/**
	 * @var ModelsTaxon
	 */
	protected PpciModel $dataclass;


	function __construct()
	{
		parent::__construct();
		$this->dataclass = new ModelsTaxon;
		$this->keyName = "taxon_id";
		if (isset($_REQUEST[$this->keyName])) {
			$this->id = $_REQUEST[$this->keyName];
		}
	}
	function list()
	{
		$this->vue = service('Smarty');
		$this->vue->set($this->dataclass->getListe(1), "data");
		$this->vue->set("param/taxonList.tpl", "corps");
		return $this->vue->send();
	}
	function change()
	{
		$this->vue = service('Smarty');
		$this->dataRead($this->id, "param/taxonChange.tpl");
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

	function searchAjax()
	{
		$this->vue = service("AjaxView");
		$this->vue->set($this->dataclass->search($_REQUEST["name"], $_REQUEST["freshwater"], $_REQUEST["noFreshcode"]));
		return $this->vue->send();
	}

	function lireAjax()
	{
		$this->vue = service("AjaxView");
		$this->vue->set($this->dataclass->lire($_REQUEST["taxon_id"]));
		return $this->vue->send();
	}
	function getListCode()
	{
		$this->vue = service("AjaxView");
		$this->vue->set($this->dataclass->getListCode($_REQUEST["freshwater"]));
		return $this->vue->send();
	}
	function getFromCode()
	{
		$this->vue = service("AjaxView");
		$this->vue->set($this->dataclass->getFromCode($_REQUEST["code"], $_REQUEST["freshwater"]));
		return $this->vue->send();
	}
}
