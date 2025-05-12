<?php

namespace App\Libraries;

use App\Models\Detection;
use App\Models\FunctionType;
use App\Models\ImportColumn;
use App\Models\ImportDescription;
use App\Models\ImportFunction;
use App\Models\IndividualTracking;
use App\Models\Location;
use App\Models\ProbeMeasure;
use App\Models\Project;
use App\Models\TelemetryImportInterface;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ImportExec extends PpciLibrary
{
    /**
     * @var Models
     */
    protected PpciModel $dataclass;
    public Project $project;
    public ImportDescription $importDescription;
    public int $idMin, $idMax, $idGenerate;

    function __construct()
    {
        $this->vue = service('Smarty');
        $this->importDescription = new ImportDescription;
        $this->vue->set($this->importDescription->getListe("import_description_name"), "imports");
        $this->project = new Project;
        $this->vue->set($this->project->getProjectsActive(1, $_SESSION["projects"]), "projects");
        $this->vue->set("import/importExec.tpl", "corps");
    }

    function display() {
        return $this->vue->send();
    }

    function exec()
    {
        /**
         * Treatment of the import
         */

        /**
         * @var TelemetryImportInterface
         */
        $importDataClass = null;
        if (isset($_FILES["filename"])) {
            /**
             * Verify the project_id
             */
            if ($this->project->isAuthorized($_POST["project_id"], $_SESSION["projects"])) {
                $fdata = $_FILES['filename'];
                if ($fdata["error"] == 0 && $fdata["size"] > 0 && $_REQUEST["import_description_id"] > 0 /*&& $_POST["sensor_id"] > 0*/) {
                    $importParam = $this->importDescription->getDetail($_REQUEST["import_description_id"]);
                    $this->vue->set(1, "isTreated");
                    /**
                     * $errors: list of errors
                     * Structure: array ["lineNumber", "content"]
                     */
                    $errors = array();
                    /**
                     * Instanciate data classes
                     */
                    switch ($importParam["import_type_id"]) {
                        case 1:
                            /**
                             * Detection
                             */
                            $individualTracking = new IndividualTracking;
                            $individualTracking->project_id = $_POST["project_id"];
                            $importDataClass = new Detection;
                            $importDataClass->autoFormatDate = false;
                        case 3:
                            /**
                             * Manual detection
                             */
                            $individualTracking = new IndividualTracking;
                            $individualTracking->project_id = $_POST["project_id"];
                            $importDataClass = new Location;
                            $importDataClass->autoFormatDate = false;
                        case 2:
                            /**
                             * Probe data
                             */
                            $importDataClass = new ProbeMeasure;
                            $importDataClass->autoFormatDate = false;
                    }
                }
                $functionType = new FunctionType;
                $importFunction = new ImportFunction;
                $importColumn = new ImportColumn;
                $columns = $importColumn->getListByColumnNumber($importParam["import_description_id"]);
                $functions = $importFunction->getListFromParent($importParam["import_description_id"], "execution_order, column_number");
                $import = new FiloImport;
                $numLineDisplay = 0;
                $dataDisplay = array();
                $this->idMin = 999999999;
                $this->idMax = 0;
                $continue = true;
                try {
                    $import->initFile($fdata["tmp_name"], $importParam["separator"]);
                    $numLine = 0;
                    $numberintransaction = 0;
                    $transactionnumber = 1;
                    $data = array();
                    $_POST["rewrite"] == 1 ? $rewrite_mod = true : $rewrite_mod = false;
                    /**
                     * Treatment of each line
                     */
                    if (!$_REQUEST["testMode"] == 1) {
                        $db = $this->dataclass->db;
                        $db->transBegin();
                    }
                    $linecount = 0;
                    $lineblock = 1;
                    $errors[]["content"] = sprintf(_("Début d'importation à %s"), date($_SESSION["MASKDATELONG"]));
                    while ($continue) {
                        $line = $import->readLine();
                        if ($line) {
                            $numberintransaction++;
                            if ($numberintransaction == 100000) {
                                $db->transCommit();
                                $errors[] = array("content" => sprintf(_("%s lignes commitées (données stockées de manière pérenne)"), $numberintransaction * $transactionnumber));
                                $transactionnumber++;
                                $db = $this->dataclass->db;
                                $db->transBegin();
                                $numberintransaction = 1;
                            }
                            $linecount++;
                            if ($linecount > 10000) {
                                $linecount = 0;
                                $errors[]["content"] = sprintf(_("%1s lignes importées à %2s"), $lineblock * 10000, date($_SESSION["MASKDATELONG"]));
                                $lineblock++;
                            }
                            $numLine++;
                            if ($numLine >= $importParam["first_line"]) {
                                /**
                                 * Apply all functions for the current row
                                 */
                                try {
                                    foreach ($functions as $function) {
                                        $numColumn = $function["column_number"];
                                        $result = $functionType->functionCall($function["function_name"], $line, array("columnNumber" => $numColumn, "arg" => $function["arguments"]));
                                        if ($function["column_result"] > 0) {
                                            $line[$numColumn - 1] = $result;
                                        } else {
                                            if (is_array($result)) {
                                                $line = $result;
                                            }
                                        }
                                    }
                                    /**
                                     * Generate the result of the read of the line
                                     */
                                    $row = array();
                                    foreach ($columns as $key => $value) {
                                        $row[$value] = $line[$key - 1];
                                    }

                                    /**
                                     * Test mode
                                     */
                                    if ($_REQUEST["testMode"] == 1) {
                                        if ($numLineDisplay < $_REQUEST["nbLines"]) {
                                            $dataDisplay[] = $row;
                                            $numLineDisplay++;
                                        }
                                        if ($numLine == $_REQUEST["nbLines"]) {
                                            $continue = false;
                                        }
                                    } else {
                                        /**
                                         * Import mode
                                         */
                                        if (!isset($row["antenna_id"])) {
                                            $row["antenna_id"] = $_POST["sensor_id"];
                                        }
                                        $row["probe_id"] = $_POST["sensor_id"];
                                        $this->idGenerate = $importDataClass->importData($row, $rewrite_mod);
                                        if ($this->idGenerate < $this->idMin) {
                                            $this->idMin = $this->idGenerate;
                                        }
                                        if ($this->idGenerate > $this->idMax) {
                                            $this->idMax = $this->idGenerate;
                                        }
                                    }
                                } catch (PpciException $fte) {
                                    $errors[] = array("lineNumber" => $numLine, "content" => $fte->getMessage());
                                }
                            }
                        } else {
                            $continue = false;
                        }
                    }
                    $errors[]["content"] =  sprintf(_("Fin de traitement à %s"), date($_SESSION["MASKDATELONG"]));
                    if (!$_REQUEST["testMode"] == 1) {
                        $db->transCommit();
                        $errors[]["content"] = sprintf(_("Nombre de lignes traitées : %s"), $numLine);
                        $errors[]["content"] = sprintf(_("Id mini généré : %s"), $this->idMin);
                        $errors[]["content"] = sprintf(_("Id maxi généré : %s"), $this->idMax);
                    }
                } catch (PpciException $ie) {
                    $errors[]["content"] = $ie->getMessage();
                } catch (PpciException $oe) {
                    if (!$_REQUEST["testMode"] == 1) {
                        $errors[] = array("lineNumber" => $numLine, "content" => sprintf(_("Erreur d'écriture en table. Message d'erreur de la base de données : %s"), $oe->getMessage()));
                        $this->message->set(_("L'importation a échoué. Consultez les messages dans le tableau"), true);
                        $this->message->setSyslog($oe->getMessage());
                        if ($db->transEnabled) {
                            $db->transRollback();
                        }
                    }
                } finally {
                    $import->fileClose();
                }
                $this->vue->set($errors, "errors");
                $this->vue->set($dataDisplay, "data");
                $this->vue->set($_REQUEST["testMode"], "testMode");
            } else {
                $this->message->set(_("L'import ne peut être effectué, des paramètres sont manquants ou le fichier est vide"), true);
            }
        } else {
            $this->message->set(_("L'import ne peut être effectué, le projet indiqué n'est pas autorisé"),true);
        }
    }
}
