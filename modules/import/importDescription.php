<?php
include_once 'modules/classes/import/import_description.class.php';
$dataClass = new ImportDescription($bdd, $ObjetBDDParam);
$keyName = "import_description_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        $vue->set($dataClass->getListe(), "imports");
        $vue->set("import/importDescriptionList.tpl", "corps");
        break;
    case "display":
        $vue->set($dataClass->getDetail($id), "data");
        $vue->set("import/importDescriptionDisplay.tpl", "corps");
        include_once "modules/classes/import/import_function.class.php";
        $importFunction = new ImportFunction($bdd, $ObjetBDDParam);
        $vue->set($importFunction->getListFromParent($id), "functions");
        include_once "modules/classes/import/import_column.class.php";
        $importColumn = new ImportColumn($bdd, $ObjetBDDParam);
        $vue->set($importColumn->getListFromParent($id, "column_order"), "columns");
        break;
    case "change":
        dataRead($dataClass, $id, "import/importDescriptionChange.tpl");
        include_once "modules/classes/param.class.php";
        $csv = new Param($bdd, "csv_type");
        $vue->set($csv->getListe(1), "csvTypes");
        $import = new Param($bdd, "import_type");
        $vue->set($import->getListe(1), "importTypes");
        break;
    case "write":
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        try {
            $bdd->beginTransaction();
            dataDelete($dataClass, $id, true);
            $bdd->commit();
            $module_coderetour = 1;
        } catch (Exception $e) {
            $bdd->rollback();
        }
        break;
    case "duplicate":
        try {
            $bdd->beginTransaction();
            $newId = $dataClass->duplicate($id);
            if ($newId > 0) {
                $_REQUEST[$keyName] = $newId;
                $module_coderetour = 1;
                $bdd->commit();
                $message->set(_("Duplication effectuée"));
            } else {
                $bdd->rollback();
                $module_coderetour = -1;
            }
        } catch (Exception $e) {
            $message->set(_("La duplication a échoué. Si le problème se reproduit, contactez l'administrateur de l'application"), true);
            $message->setSyslog($e->getMessage());
            $bdd->rollback();
            $module_coderetour = -1;
        }
}
