<?php
$tablename = $t_module["tablename"];
include_once 'modules/classes/param.class.php';
$dataClass = new Param($bdd, $tablename);
$keyName = $tablename . "_id";
$id = $_REQUEST[$keyName];
$description = $t_module["tabledescription"];

if (!function_exists("generateSet")) {
	function generateSet($vue, $tablename, $description)
	{
		$vue->set($tablename . "_id", "fieldid");
		$vue->set($tablename . "_name", "fieldname");
		$vue->set($tablename . "_code", "fieldcode");
		$vue->set(_($description), "tabledescription");
		$vue->set($tablename, "tablename");
	}
}

switch ($t_module["param"]) {
	case "list":
		$vue->set($dataClass->getListe(1), "data");
		$vue->set("param/paramList.tpl", "corps");
		generateSet($vue, $tablename, $description);
		break;
	case "display":

		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
		dataRead($dataClass, $id, "param/paramChange.tpl");
		generateSet($vue, $tablename, $description);
		break;
	case "write":
		/*
		 * write record in database
		 */
		$id = dataWrite($dataClass, $_REQUEST);
		if ($id > 0) {
			$_REQUEST[$keyName] = $id;
		}
		break;
	case "delete":
		/*
		 * delete record
		 */
		dataDelete($dataClass, $id);
		break;
}
