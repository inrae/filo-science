<?php
include_once 'modules/classes/protocol.class.php';
$dataClass = new Protocol($bdd, $ObjetBDDParam);
$keyName = "protocol_id";
$id = $_REQUEST[$keyName];


switch ($t_module["param"]) {
    case "list":
        $vue->set($dataClass->getListProtocol(), "data");
        $vue->set("param/protocolList.tpl", "corps");
        break;
    case "change":
        dataRead($dataClass, $id, "param/protocolChange.tpl");
        require_once "modules/classes/analysis_template.class.php";
        $at = new AnalysisTemplate($bdd, $ObjetBDDParam);
        $vue->set($at->getListe(1), "dataat");
        break;
    case "display":
        $vue->set($dataClass->getDetail($id), "data");
        $vue->set("param/protocolDisplay.tpl", "corps");
        /**
         * Get the associated documents
         */
        include_once 'modules/classes/document.class.php';
        $document = new Document($bdd, $ObjetBDDParam);
        $vue->set($document->getListFromParent("protocol", $id), "dataDoc");
        $vue->set("protocol", "moduleParent");
        $vue->set($id, "parent_id");

        /**
         * List of measures templates
         */
        include_once 'modules/classes/measure_template.class.php';
        $mt = new Measure_template($bdd, $ObjetBDDParam);
        $vue->set($mt->getListFromProtocol($id), "mtdata");
        break;

    case "write":
        /*
		 * write record in database
		 */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        /*
		 * delete record
		 */
        dataDelete($dataClass, $id);
        break;
}
