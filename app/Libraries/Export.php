<?php 
namespace App\Libraries;

use App\Models\Export as ModelsExport;
use App\Models\ExportModel;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Export extends PpciLibrary { 
    /**
     * @var ModelsExport
*/
    protected PpciModel $dataclass;
    public ExportModel $exportModel;    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsExport;
        $this->exportModel = new ExportModel;
        $dataclass->modeDebug = false;
    }

    function exec() {
        try {
            $model = array();
            if ($_REQUEST["export_model_id"] > 0) {
                $model = $exportModel->lire($_REQUEST["export_model_id"]);
            } else if (!empty($_REQUEST["export_model_name"]) ) {
                $model = $exportModel->getModelFromName($_REQUEST["export_model_name"]);
            }
            if ($model["export_model_id"] > 0) {
                $export->initModel($model["pattern"]);
                $data = array();
                foreach ($export->getListPrimaryTables() as $key => $table) {
                    if ($key == 0 && count($_REQUEST["keys"]) > 0) {
                        /**
                         * Specific to Filo-Science to get the real values of the keys
                         */
                        $keys = array();
                        if (!empty($_REQUEST["translator"]) ) {
                            foreach ($_REQUEST["keys"] as $k) {
                                $keys[] = $_SESSION[$_REQUEST["translator"]]->getValue($k);
                            }
                        } else {
                            $keys = $_REQUEST["keys"];
                        }
                        /**
                         * set the list of records for the first item
                         */
                        $data[$table] = $export->getTableContent($table, $keys);
                    } else {
                        $data[$table] = $export->getTableContent($table);
                    }
                }
                if ($export->modeDebug) {
                    throw new ExportException("Debug mode: no file generated");
                }
                $this->vue->setParam(array("filename" => $_SESSION["APPLI_code"] . '-' . date('YmdHis') . ".json"));
                $this->vue->set(json_encode($data));
            } else {
                throw new ExportException(_("Le modèle d'export n'est pas défini ou n'a pas été trouvé"));
            }
        } catch (ExportException $e) {
            if (isset($_REQUEST["returnko"])) {
                $t_module["retourko"] = $_REQUEST["returnko"];
            }
            return false;
            $this->message->set($e->getMessage(), true);
            $this->message->setSyslog($e->getMessage());
        }
        }

    function importExec() {
        /**
         * set the return values
         */
        if (isset($_REQUEST["returnok"])) {
            $t_module["retourok"] = $_REQUEST["returnok"];
        }
        if (isset($_REQUEST["returnko"])) {
            $t_module["retourko"] = $_REQUEST["returnok"];
        }
        /**
         * Verify the project, if it's specified
         */
        $testProject = true;
        if (isset($_REQUEST["project_id"])) {
            if (!verifyProject($_REQUEST["project_id"])) {
                $testProject = false;
            }
        }
        if (($_REQUEST["export_model_id"] > 0 || !empty($_REQUEST["export_model_name"])) && $_FILES["filename"]["size"] > 0 && $testProject) {
            if ($_REQUEST["export_model_id"]) {
                $model = $exportModel->lire($_REQUEST["export_model_id"]);
            } else {
                $model = $exportModel->getModelFromName($_REQUEST["export_model_name"]);
            }
            $export->initModel($model["pattern"]);
            $filename = $_FILES["filename"]["tmp_name"];
            $realFilename = $_FILES["filename"]["name"];
            $filename = str_replace("../", "", $filename);
            $handle = fopen($filename, 'r');
            if (!$handle) {
                $this->message->set(sprintf(_("Fichier %s non trouvé ou non lisible"), $filename), true);
                return false;
            } else {
                $contents = fread($handle, filesize($filename));
                fclose($handle);
                $data = json_decode($contents, true);
                try {
                    $db = $this->dataclass->db;
$db->transBegin();
                    $firstTable = true;
                    foreach ($data as $tableName => $values) {
                        if ($firstTable && empty($_REQUEST["parentKeyName"])) {
                            $key = $_REQUEST["parentKey"];
                            /**
                             * Specific to Filo-Science
                             */
                            if (!empty($_REQUEST["translator"]) ) {
                                /**
                                 * Get the real value of the parent
                                 */
                                $key = $_SESSION[$_REQUEST["translator"]]->getValue($key);
                            }
                            $export->importDataTable($tableName, $values, 0, array($_REQUEST["parentKeyName"] => $key));
                            $firstTable = false;
                        } else {
                            $export->importDataTable($tableName, $values);
                        }
                    }
                    $db->transCommit();
                    $this->message->set(sprintf(_("Importation effectuée, fichier %s traité."), $realFilename));
                    return true;
                } catch (ExportException $e) {
                    if ($db->transEnabled) {
    $db->transRollback();
}
                    $this->message->set($e->getMessage(), true);
                    return false;
                }
            }
        } else {
            return false;
            $this->message->set(_("Paramètres d'importation manquants ou droits insuffisants"), true);
        }
        }
}
