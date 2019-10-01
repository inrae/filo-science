<?php

/**
 * ORM of table import_function
 */
class ImportFunction extends ObjetBDD
{

    /**
     * Class constructor.
     */
    public function __construct($bdd, $param = array())
    {
        $this->table = "import_function";
        $this->colonnes = array(
            "import_function_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "import_description_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "function_type_id" => array("type" => 1, "requis" => 1),
            "column_number" => array("type" => 1, "requis" => 1),
            "order" => array("type" => 1, "requis" => 1),
            "arguments" => array("type" => 0),
            "column_result" => array("type" => 1)
        );

        parent::__construct($bdd, $param);
    }
}
