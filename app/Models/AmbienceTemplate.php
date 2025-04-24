<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM of the table ambience_template
 */
class AmbienceTemplate extends PpciModel
{

    /**
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "ambience_template";
        $this->fields = array(
            "ambience_template_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "ambience_template_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "ambience_template_schema" => array("type" => 0)
        );
        parent::__construct();
    }
}
