<?php
include_once 'modules/classes/import/import_column.class.php';
$dataClass = new ImportColumn($bdd, $ObjetBDDParam);
$keyName = "import_column_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "change":
        $data = dataRead($dataClass, $id, "import/importColumnChange.tpl", $_REQUEST["import_description_id"]);
        /**
         * Get the list of columns usable during the import
         */
        include_once "modules/classes/import/import_description.class.php";
        $importDescription = new ImportDescription($bdd, $ObjetBDDParam);
        $dDesc = $importDescription->getDetail($_REQUEST["import_description_id"]);
        $vue->set(explode(",", $dDesc["column_list"]),"columns");
        break;
    case "write":
    printr($_REQUEST);
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        dataDelete($dataClass, $id);
        break;
}
