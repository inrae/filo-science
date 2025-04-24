<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM of table parameter_measure_type
 */
class ParameterMeasureType extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "parameter_measure_type";
        $this->fields = array(
            "parameter_measure_type_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "parameter" => array("type" => 0, "requis" => 1),
            "unit" => array("type" => 0)
        );
        parent::__construct();
    }
}
