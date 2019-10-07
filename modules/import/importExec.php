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
    if ($fdata["error"] == 0 && $fdata["size"] > 0) {
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
        switch($importParam["import_type_id"]) {
            case 1:
            include_once "modules/classes/tracking/individual_tracking.class.php";
            $individualTracking = new IndividualTracking($bdd, $ObjetBDDParam);
            break;
            case 2:
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
        try {
            $import->initFile($fdata["tmp_name"], $importParam["separator"]);
            $numLine = 0;
            $data = array();
            /**
             * Treatment of each line
             */
            while (($line = $import->readLine()) !== false) {
                $numLine++;
                /**
                 * Apply all functions for the current row
                 */
                try {
                    foreach ($functions as $function) {
                        $numColumn = $function["column_number"];
                        $result = $functionType->functionCall($function["function_name"], $line, array("columnNumber" => $numColumn, "arg" => $function["arguments"]));
                        if ($function["column_result"] > 0) {
                            $line[$numColumn - 1] = $result;
                        }
                    }
                    /**
                     * Traitment of import
                     */
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
                            $numLineDisplay ++;
                        }
                    }
                } catch (FunctionTypeException $fte) {
                    $errors[] = array("lineNumber" => $numLine, "content" => $fte->getMessage());
                }
            }
        } catch (ImportException $ie) {
            $errors[]["content"] = $ie->getMessage();
        } finally {
            $import->fileClose();
        }
        $vue->set($errors, "errors");
        $vue->set($dataDisplay, "data");
        $vue->set($_REQUEST["testMode"], "testMode");
    }
}
