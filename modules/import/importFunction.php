<?php
include_once 'modules/classes/import/import_function.class.php';
$dataClass = new ImportFunction($bdd, $ObjetBDDParam);
$keyName = "import_function_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "change":
        dataRead($dataClass, $id, "import/importFunctionChange.tpl", $_REQUEST["import_description_id"]);
        include_once "modules/classes/import/function_type.class.php";
        $functionType = new FunctionType($bdd, $ObjetBDDParam);
        $vue->set($functionType->getListe("function_name"), "functions");
        break;
    case "write":
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        dataDelete($dataClass, $id, true);
        break;
    case "getFunctionDescription":
        include_once "modules/classes/import/function_type.class.php";
        $functionType = new FunctionType($bdd, $ObjetBDDParam);
        $vue->set($functionType->getDescription($_REQUEST["function_type_id"]));
        break;
}
