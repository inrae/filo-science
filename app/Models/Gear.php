<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM for the table gear
 */
class Gear extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "gear";
        $this->fields = array(
            "gear_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "gear_name" => array("requis" => 1),
            "gear_length" => array("type" => 1),
            "gear_height" => array("type" => 1),
            "mesh_size" => array("type" => 0)
        );
        parent::__construct();
    }
}
