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
    case "display":
        $data = $dataClass->lire($id);
        $vue->set($data, "data");
        $vue->set(json_decode($data["pattern"], true), "pattern");
        $vue->set("import/exportModelDisplay.tpl", "corps");
        break;
    case "change":
        dataRead($dataClass, $id, "import/exportModelChange.tpl");
        break;
    case "duplicate":
        $data = $dataClass->lire($id);
        $data["export_model_id"] = 0;
        $data["export_model_name"] .= " - copy";
        $vue->set($data, "data");
        $vue->set("import/exportModelChange.tpl", "corps");
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
