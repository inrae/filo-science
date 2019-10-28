<?php

/**
 * ORM of the table export_model
 */
class ExportModel extends ObjetBDD
{
    /**
     * Class constructor.
     */
    public function __construct($bdd, $param = array())
    {
        $this->table = "export_model";
        $this->colonnes = array(
            "export_model_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "export_model_name" => array("type" => 0, "requis" => 1),
            "pattern" => array("type" => 0)
        );

        parent::__construct($bdd, $param);
    }
}