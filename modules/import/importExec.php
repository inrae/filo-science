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
if (isset($_FILES["fileName"])) {
    $fdata = $_FILES['fileName'];
    if ($fdata["error"] == 0 && $fdata["size"] > 0) {
        $importParam = $importDescription->lire($_REQUEST["import_description_id"]);
        $vue->set(1, "isTreated");
        /**
         * $errors: list of errors
         * Structure: array ["lineNumber", "content"]
         */
        $errors = array();
        include_once "modules/classes/import/import.class.php";
        include_once "modules/classes/import/function_type.class.php";
        include_once "modules/classes/import/import_function.class.php";
        $functionType = new FunctionType($bdd);
        $importFunction = new ImportFunction($bdd);
        $functions = $importFunction->getListFromParent($importParam["import_description_id"], "execution_order, column_number");
        try {
            $import = new FiloImport();
            $dataRaw = $import->readFile($fdata["tmp_name"], $importParam["separator"]);
            $numLine = 0;
            $data = array();
            /**
             * Treatment of each line
             */
            foreach ($dataRaw as $row) {
                $numLine ++;
                /**
                 * Apply all functions for the current row
                 */
                try {
                    foreach ($functions as $function) {
                        $numColumn = $function["column_number"] - 1;
                        $result = $functionType->functionCall($function["function_name"],$row, array("columnNumber"=>$numColumn, "arg"=>$function["arguments"]));
                        if ($function["column_result"] > -1) {
                            $row[$numColumn] = $result;
                        }
                    }
                    $data[] = $row;
                } catch (FunctionTypeException $fte) {
                    $errors[] = array ("lineNumber"=>$numLine, "content"=>$fte->getMessage());
                }
            }
            /**
             * $data contains the data ready to import
             */


             if ($_REQUEST["testMode"] == 1) {
                 $numLineDisplay = 1 ;
                 $dataDisplay = array();
                 foreach ($data as $row) {
                     $numLineDisplay ++;
                     if ($numLineDisplay > $_REQUEST["nbLines"]) {
                         break;
                     }
                     $dataDisplay[] = $row;
                 }
                 $vue->set($dataDisplay, "data");
             }
        } catch (ImportException $ie) {
            $errors[]["content"] = $ie->getMessage();
        }
        $vue->set($errors, "errors");
    }
}

