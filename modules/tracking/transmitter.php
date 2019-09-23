<?php
require_once 'modules/classes/transmitter_type.class.php';
$dataClass = new TransmitterType($bdd, $ObjetBDDParam);
$keyName = "transmitter_type_id";
if (strlen($_REQUEST[$keyName]) == 0) {
    $t_module["param"] = "error";
    $t_module["retourko"] = "default";
    $module_coderetour = -1;
}

switch ($t_module["param"]) {
    case "change":
        /**
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record 
         */  
        dataRead($dataClass, $id, "tracking/transmitter_typeList.tpl", $sequence_id);
        break;
    case "write":
        /**
         * write record in database
         */
        $id = dataWrite($dataClass, $data);
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
