<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class Analysis extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "analysis";
        $this->fields = array(
            "analysis_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "sequence_id" => array("type" => 1, "parentAttrib" => 1, "requis" => 1),
            "analysis_date" => array("type" => 3, "requis" => 1),
            "ph" => array("type" => 1),
            "temperature" => array("type" => 1),
            "o2_pc" => array("type" => 1),
            "o2_mg" => array("type" => 1),
            "salinity" => array("type" => 1),
            "conductivity" => array("type" => 1),
            "secchi" => array("type" => 1),
            "other_analysis" => array("type" => 0),
            "uuid" => array("type" => 0)
        );
        parent::__construct();
    }
}
