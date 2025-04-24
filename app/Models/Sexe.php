<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM for the table sexe
 */
class Sexe extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "sexe";
        $this->fields = array(
            "sexe_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "sexe_name" => array("requis" => 1),
            "sexe_code" => array("requis" => 1)
        );
        parent::__construct();
    }
}
