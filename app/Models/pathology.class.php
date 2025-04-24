<?php 
namespace App\Models;
use Ppci\Models\PpciModel;
/**
 * ORM for the table pathology
 */
class Pathology extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "pathology";
        $this->fields = array(
            "pathology_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "pathology_name" => array("requis" => 1),
            "pathology_code" => array("type" => 0),
            "pathology_description" => array("type" => 0)
        );
        parent::__construct();
    }
}
