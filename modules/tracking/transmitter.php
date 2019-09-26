<?php
require_once 'modules/classes/transmitter_type.class.php';
$dataClass = new TransmitterType($bdd, $ObjetBDDParam);
$keyName = "transmitter_type_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        $vue->set($dataClass->getListe(), "data");
        $vue->set("tracking/transmitter_typeList.tpl", "corps");
        break;
    case "change":
        dataRead($dataClass, $id, "tracking/transmitter_typeChange.tpl");
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
