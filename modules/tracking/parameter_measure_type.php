<?php
include_once 'modules/classes/tracking/parameter_measure_type.class.php';
$dataClass = new ParameterMeasureType($bdd, $ObjetBDDParam);
$keyName = "parameter_measure_type_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        $vue->set($dataClass->getListe(), "parameters");
        $vue->set("tracking/parameterMeasureTypeList.tpl", "corps");
        break;
    case "change":
        dataRead($dataClass, $id, "tracking/parameterMeasureTypeChange.tpl");
        break;
    case "write":
        /**
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        /**
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
}
