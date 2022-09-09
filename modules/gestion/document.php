<?php
include_once 'modules/classes/document.class.php';
$dataClass = new Document($bdd, $ObjetBDDParam);
$keyName = "document_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "change":
        /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 * moduleParent : nom du module a rappeler apres enregistrement
		 * parentType : nom de la table à laquelle sont rattaches les documents
		 * parentIdName : nom de la cle de la table parente
		 * parent_id : cle de la table parente
		 */
        dataRead($dataClass, $id, "gestion/documentChange.tpl");
        break;
    case "write":
        /*
		 * write record in database
		 */
        /*
			 * Preparation de files
			 */
        $files = array();
        $fdata = $_FILES['documentName'];
        if (is_array($fdata['name'])) {
            for ($i = 0; $i < count($fdata['name']); ++$i) {
                $files[] = array(
                    'name' => $fdata['name'][$i],
                    'type' => $fdata['type'][$i],
                    'tmp_name' => $fdata['tmp_name'][$i],
                    'error' => $fdata['error'][$i],
                    'size' => $fdata['size'][$i]
                );
            }
        } else {
            $files[] = $fdata;
        }
        foreach ($files as $file) {
            $id = $dataClass->documentEcrire($file, $_REQUEST["parent_table"], $_REQUEST["parent_id"], $_REQUEST["document_description"], $_REQUEST["document_creation_date"]);
            if ($id > 0) {
                $_REQUEST[$keyName] = $id;
                $module_coderetour = 1;
            } else {
                $module_coderetour = -1;
            }
        }
        $origine = "document";
        break;
    case "delete":
        /*
		 * delete record
		 */
        dataDelete($dataClass, $id);
        $origine = "document";
        break;
    case "get":
        /*
		 * Envoi du document au navigateur
		 * Generation du nom du document
		 */
        $tmp_name = $dataClass->prepareDocument($id, $_REQUEST["phototype"]);
        if (!empty($tmp_name) && is_file($tmp_name)) {
            /*
			 * Recuperation du type mime
			 */
            $data = $dataClass->getData($id);
            $param = array("tmp_name" => $tmp_name, "content_type" => $data["content_type"]);
            if ($_REQUEST["attached"] == 1) {
                $param["disposition"] = "attachment";
                $fn = explode('/', $tmp_name);
                $param["filename"] = $fn[count($fn) - 1];
            } else {
                $param["disposition"] = "inline";
            }
            $vue->setParam($param);
        } else {
            unset($vue);
            $module_coderetour = -1;
        }
        break;
}
