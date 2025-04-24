<?php 
namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;
/**
 * Execute the import
 */
class ImportExec {
    private $importDescription, $importFunction, $functionType ;
    private $functions = array();
    /**
     * List of all error messages recorded
     *
     * @var array
     */
    public $message = array();
    public $readLines = 0, $validLines = 0;

    /**
     * Constructor
     *
     * @param array $importDescription
     * @param ImportFunction $importFunction
     * @param FunctionType $functionType
     */
    function __construct(array $importDescription, ImportFunction $importFunction, FunctionType $functionType) {
        $this->importDescription = $importDescription;
        $this->importFunction = $importFunction;
        $this->functionType = $functionType;
        $this->functions = $importFunction->getListFromParent($importDescription["import_description_id"], "execution_order");
    }
    /**
     * Analyze each line and call all functions defined
     *
     * @param array $data: content of the file
     * @return array: data usable without all errors
     */
    function parseData(array $data):array {
        $dataParse = array();

        foreach ($data as $row) {
            $this->readLines ++;
            try {
                foreach($this->functions as $function) {
                    $args = array ("columnNumber"=>$function["column_number"] - 1, "arg"=>$function["arguments"]);
                    $result = $this->functionType->functionCall($function["function_name"], $row, $args);
                    if ($function["column_result"] > 0) {
                        $row["column_result"] = $result;
                    }
                }
                $dataParse[] = $row;
                $this->validLines ++;
            } catch (PpciException $fe) {
                $this->message[] = array("lineNumber"=>$this->readLines, "content"=>$fe->getMessage());
            }
        }
        return $dataParse;
    }
}