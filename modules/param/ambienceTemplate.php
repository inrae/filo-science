<?php
include_once 'modules/classes/ambience_template.class.php';
$dataClass = new AmbienceTemplate($bdd, $ObjetBDDParam);
$keyName = "ambience_template_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
  case "list":
    $vue->set($dataClass->getListe(1), "data");
    $vue->set("param/ambienceTemplateList.tpl", "corps");
    break;
  case "change":
    /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
    dataRead($dataClass, $id, "param/ambienceTemplateChange.tpl");
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
