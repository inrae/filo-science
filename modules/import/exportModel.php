<?php
include_once 'modules/classes/import/export_model.class.php';
$dataClass = new ExportModel($bdd, $ObjetBDDParam);
$keyName = "export_model_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        $vue->set($dataClass->getListe("export_model_name"), "data");
        $vue->set("import/exportModelList.tpl", "corps");
        break;
    case "change":
        dataRead($dataClass, $id, "import/exportModelChange.tpl");
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