<?php

/**
 * Data to display the form
 */
include_once "modules/classes/import/import_description.class.php";
$importDescription = new ImportDescription($bdd, $ObjetBDDParam);
$vue->set($importDescription->getListe("import_description_name"), "imports");

include_once 'modules/classes/project.class.php';
$project = new Project($bdd, $ObjetBDDParam);
$vue->set($project->getProjectsActive(1, $_SESSION["projects"]), "projects");

$vue->set("import/importExec.tpl", "corps");
/**
 * Treatment of the import
 */

if (isset($_FILES["filename"])) {
    $fdata = $_FILES['filename'];
    if ($fdata["error"] == 0 && $fdata["size"] > 0 && $_REQUEST["import_description_id"] > 0 && $_POST["sensor_id"] > 0) {
        $importParam = $importDescription->getDetail($_REQUEST["import_description_id"]);
        $vue->set(1, "isTreated");
        /**
         * $errors: list of errors
         * Structure: array ["lineNumber", "content"]
         */
        $errors = array();
        include_once "modules/classes/import/import.class.php";
        include_once "modules/classes/import/function_type.class.php";
        include_once "modules/classes/import/import_function.class.php";
        include_once "modules/classes/import/import_column.class.php";
        /**
         * Instanciate data classes
         */
        switch ($importParam["import_type_id"]) {
            case 1:
                include_once "modules/classes/tracking/individual_tracking.class.php";
                $individualTracking = new IndividualTracking($bdd, $ObjetBDDParam);
                include_once "modules/classes/tracking/detection.class.php";
                $importDataClass = new Detection($bdd, $ObjetBDDParam);
                $importDataClass->auto_date = 0;
                break;
            case 3:
                include_once "modules/classes/tracking/individual_tracking.class.php";
                $individualTracking = new IndividualTracking($bdd, $ObjetBDDParam);
                include_once "modules/classes/tracking/location.class.php";
                $importDataClass = new Location($bdd, $ObjetBDDParam);
                $importDataClass->auto_date = 0;
                break;
            case 2:
                include_once "modules/classes/tracking/probe_measure.class.php";
                $importDataClass = new ProbeMeasure($bdd, $ObjetBDDParam);
                $importDataClass->auto_date = 0;
                break;
        }
        $functionType = new FunctionType($bdd);
        $importFunction = new ImportFunction($bdd);
        $importColumn = new ImportColumn($bdd, $ObjetBDDParam);
        $columns = $importColumn->getListByColumnNumber($importParam["import_description_id"]);
        $functions = $importFunction->getListFromParent($importParam["import_description_id"], "execution_order, column_number");
        $import = new FiloImport();
        $numLineDisplay = 0;
        $dataDisplay = array();
        $idMin = 999999999;
        $idMax = 0;
        $continue = true;
        try {
            $import->initFile($fdata["tmp_name"], $importParam["separator"]);
            $numLine = 0;
            $data = array();
            /**
             * Treatment of each line
             */
            if (!$_REQUEST["testMode"] == 1) {
                $bdd->beginTransaction();
            }
            while ($continue) {
                $line = $import->readLine();
                if ($line) {
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
                                $row["antenna_id"] = $_POST["sensor_id"];
                                $row["probe_id"] = $_POST["sensor_id"];
                                $idGenerate = $importDataClass->ecrire($row);
                                if ($idGenerate < $idMin) {
                                    $idMin = $idGenerate;
                                }
                                $idMax = $idGenerate;
                            }
                        } catch (FunctionTypeException $fte) {
                            $errors[] = array("lineNumber" => $numLine, "content" => $fte->getMessage());
                        }
                    }
                } else {
                    $continue = false;
                }
            }
            if (!$_REQUEST["testMode"] == 1) {
                $bdd->commit();
                $errors[] = array("content" => _("Id mini généré :") . $idMin);
                $errors[] = array("content" => _("Id maxi généré :") . $idMax);
            }
        } catch (ImportException $ie) {
            $errors[]["content"] = $ie->getMessage();
        } catch (ObjetBDDException $oe) {
            if (!$_REQUEST["testMode"] == 1) {
                $errors[] = array("lineNumber" => $numLine, "content" => _("Erreur d'écriture en table. Message d'erreur de la base de données : ") . $oe->getMessage());
                $message->set(_("L'importation a échoué. Consultez les messages dans le tableau"), true);
                $message->setSyslog($oe->getMessage());
                $bdd->rollback();
            }
        } finally {
            $import->fileClose();
        }
        $vue->set($errors, "errors");
        $vue->set($dataDisplay, "data");
        $vue->set($_REQUEST["testMode"], "testMode");
    } else {
        $message->set(_("L'import ne peut être effectué, des paramètres sont manquants ou le fichier est vide"), true);
    }
}
