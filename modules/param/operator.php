<?php
include_once 'modules/classes/operator.class.php';
$dataClass = new Operator($bdd, $ObjetBDDParam);
$keyName = "operator_id";
$id = $_REQUEST[$keyName];


switch ($t_module["param"]) {
	case "list":
		$vue->set($dataClass->getListe("name,firstname"), "data");
		$vue->set("param/operatorList.tpl", "corps");
		break;
	case "change":
		/*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record 
		 */
		dataRead($dataClass, $id, "param/operatorChange.tpl");
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
