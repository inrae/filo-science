<?php
include_once 'modules/classes/measure_template.class.php';
include_once 'modules/classes/protocol.class.php';
$dataClass = new Protocol($bdd, $ObjetBDDParam);
$measureTemplate = new MeasureTemplate($bdd, $ObjetBDDParam);
$keyName = "protocol_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "change":
        dataRead($dataClass, $id, "param/protocolMeasureChange.tpl");
        $vue->set($measureTemplate->getTotalListForProtocol($id), "measures");
        break;
    case "write":
        try {
            $bdd->beginTransaction();
            $dataClass->ecrireTableNN("protocol_measure", "protocol_id", "measure_template_id", $id, $_POST["measure_template_id"]);
            $bdd->commit();
            $module_coderetour = 1;
        } catch (Exception $e) {
            $message->set(_("Echec d'écriture de la liste des modèles de mesures rattachées au protocole"), true);
            $message->setSyslog($e->getMessage());
            $module_coderetour = -1;
            $bdd->rollback();
        }
        break;
}
