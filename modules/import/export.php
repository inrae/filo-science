<?php
include_once "modules/classes/import/export.class.php";
include_once "modules/classes/import/export_model.class.php";
$exportModel = new ExportModel($bdd, $ObjetBDDParam);
$export = new Export($bdd);

switch ($t_module["param"]) {
    case "exec":
        if ($_REQUEST["export_model_id"] > 0) {
            $model = $exportModel->lire($_REQUEST["export_model_id"]);
            $export->initModel($model["pattern"]);
            $data = array();
            foreach ($export->getListPrimaryTables() as $table) {
                $data[$table] = $export->getTableContent($table);
            }
            $vue->setParam(array("filename" => "test.json"));
            $vue->set(json_encode($data));
        }
        break;

    case "importExec":
        if ($_REQUEST["export_model_id"] > 0 && strlen($_REQUEST["filename"]) > 0) {
            $model = $exportModel->lire($_REQUEST["export_model_id"]);
            $export->initModel($model["pattern"]);
            $filename = $_REQUEST["filename"];
            $handle = fopen($filename, 'r');
            if (!$handle  ) {
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
