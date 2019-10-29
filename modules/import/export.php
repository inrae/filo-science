<?php
include_once "modules/classes/import/export.class.php";
include_once "modules/classes/import/export_model.class.php";
$exportModel = new ExportModel($bdd, $ObjetBDDParam);
$export = new Export($bdd);

switch ($t_module["param"]) {
    case "exec":
        try {
            $model = array();
            if ($_REQUEST["export_model_id"] > 0) {
                $model = $exportModel->lire($_REQUEST["export_model_id"]);
            } else if (strlen($_REQUEST["export_model_name"]) > 0) {
                $model = $exportModel->getModelFromName($_REQUEST["export_model_name"]);
            }
            if ($model["export_model_id"] > 0) {
                $export->initModel($model["pattern"]);
                $data = array();
                foreach ($export->getListPrimaryTables() as $key => $table) {
                    if ($key == 0 && count($_REQUEST["keys"]) > 0) {
                        /**
                         * set the list of records for the first item
                         */
                        $data[$table] = $export->getTableContent($table, $_REQUEST["keys"]);
                    } else {
                        $data[$table] = $export->getTableContent($table);
                    }
                }
                $vue->setParam(array("filename" => $_SESSION["APPLI_code"] . '-' . date('YmdHis') . ".json"));
                $vue->set(json_encode($data));
            } else {
                throw new ExportException(_("Le modèle d'export n'est pas défini ou n'a pas été trouvé"));
            }
        } catch (ExportException $e) {
            if (isset($_REQUEST["returnko"])) {
                $t_module["retourko"] = $_REQUEST["returnko"];
            }
            $module_coderetour = -1;
            $message->set($e->getMessage(), true);
            $message->setSyslog($e->getMessage());
        }
        break;

    case "importExec":
        if ($_REQUEST["export_model_id"] > 0 && strlen($_REQUEST["filename"]) > 0) {
            $model = $exportModel->lire($_REQUEST["export_model_id"]);
            $export->initModel($model["pattern"]);
            $filename = $_REQUEST["filename"];
            $handle = fopen($filename, 'r');
            if (!$handle) {
                $message->set(sprintf(_("Fichier %s non trouvé ou non lisible"), $filename), true);
            } else {
                $contents = fread($handle, filesize($filename));
                fclose($handle);
                $data = json_decode($contents, true);
                try {
                    $bdd->beginTransaction();
                    foreach ($data as $tableName => $values) {
                        $export->importDataTable($tableName, $values);
                    }
                    $bdd->commit();
                    $message->set(_("Importation effectuée"));
                    $module_coderetour = 1;
                } catch (Exception $e) {
                    $bdd->rollback();
                    $message->set($e->getMessage(), true);
                    $module_coderetour = -1;
                }
            }
        } else {
            $message->set(_("Paramètres d'importation manquants"), true);
        }
        break;
}
