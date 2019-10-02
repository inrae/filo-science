<?php
include_once 'modules/classes/import/import_type.class.php';
$dataClass = new ImportType($bdd, $ObjetBDDParam);
$keyName = "import_type_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        $vue->set($dataClass->getListe(), "imports");
        $vue->set("import/importTypeList.tpl", "corps");
        break;
    case "change":
        dataRead($dataClass, $id, "import/importTypeChange.tpl");

        break;
    case "write":
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        dataDelete($dataClass, $id);
       break;
}
