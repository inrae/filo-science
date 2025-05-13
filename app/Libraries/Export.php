<?php

namespace App\Libraries;

use App\Models\ExportModel;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Export extends PpciLibrary
{
    /**
     * @var ExportModel
     */
    protected PpciModel $dataclass;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ExportModel;
        $this->dataclass->modeDebug = false;
        helper("filo");
    }

    function exec()
    {
        try {
            $model = array();
            if ($_REQUEST["export_model_id"] > 0) {
                $model = $this->dataclass->lire($_REQUEST["export_model_id"]);
            } else if (!empty($_REQUEST["export_model_name"])) {
                $model = $this->dataclass->getModelFromName($_REQUEST["export_model_name"]);
            }
            //$this->dataclass->modeDebug=true;
            if ($model["export_model_id"] > 0) {
                $this->dataclass->initModel(json_decode($model["pattern"], true));
                $this->dataclass->generateStructure();
                $data = array();
                foreach ($this->dataclass->getListPrimaryTables() as $key => $table) {
                    if ($key == 0 && count($_REQUEST["keys"]) > 0) {
                        /**
                         * Specific to Filo-Science to get the real values of the keys
                         */
                        $keys = array();
                        if (!empty($_REQUEST["translator"])) {
                            foreach ($_REQUEST["keys"] as $k) {
                                $keys[] = $_SESSION[$_REQUEST["translator"]]->getValue($k);
                            }
                        } else {
                            $keys = $_REQUEST["keys"];
                        }
                        /**
                         * set the list of records for the first item
                         */
                        $data[$table] = $this->dataclass->getTableContent($table, $keys);
                    } else {
                        $data[$table] = $this->dataclass->getTableContent($table);
                    }
                }
                if ($this->dataclass->modeDebug) {
                    throw new PpciException("Debug mode: no file generated");
                }
                $this->vue = service("JsonFileView");
                $this->vue->setParam(array("filename" => $_SESSION["dbparams"]["APPLI_code"] . '-' . date('YmdHis') . ".json"));
                $this->vue->set($data);
                return $this->vue->send();
            } else {
                throw new PpciException(_("Le modèle d'export n'est pas défini ou n'a pas été trouvé"));
            }
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
            $this->message->setSyslog($e->getMessage());
            return false;
        }
    }

    function importExec()
    {
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
                $model = $this->dataclass->lire($_REQUEST["export_model_id"]);
            } else {
                $model = $this->dataclass->getModelFromName($_REQUEST["export_model_name"]);
            }
            $this->dataclass->initModel(json_decode($model["pattern"], true));
            $this->dataclass->generateStructure();
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
                
                $data = $data[0];
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
                            if (!empty($_REQUEST["translator"])) {
                                /**
                                 * Get the real value of the parent
                                 */
                                $key = $_SESSION[$_REQUEST["translator"]]->getValue($key);
                            }
                            $this->dataclass->importDataTable($tableName, $values, 0, array($_REQUEST["parentKeyName"] => $key));
                            $firstTable = false;
                        } else {
                            $this->dataclass->importDataTable($tableName, $values);
                        }
                    }
                    $db->transCommit();
                    $this->message->set(sprintf(_("Importation effectuée, fichier %s traité."), $realFilename));
                    return true;
                } catch (PpciException $e) {
                    if ($db->transEnabled) {
                        $db->transRollback();
                    }
                    $this->message->set($e->getMessage(), true);
                    return false;
                }
            }
        } else {
            $this->message->set(_("Paramètres d'importation manquants ou droits insuffisants"), true);
            return false;
        }
    }
}
