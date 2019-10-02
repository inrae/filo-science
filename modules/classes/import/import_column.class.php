<?php

/**
 * ORM of table import_column
 */
class ImportColumn extends ObjetBDD
{

    /**
     * Class constructor.
     */
    public function __construct($bdd, $param = array())
    {
        $this->table = "import_column";
        $this->colonnes = array(
            "import_column_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "import_description_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "column_order" => array("type" => 1, "requis" => 1),
            "table_column_name" => array("type" => 0),
            "is_er" => array("type" => 1, "requis" => 1, "defaultValue" => 0),
            "is_value" => array("type" => 1, "requis" => 1, "defaultValue" => 0)
        );

        parent::__construct($bdd, $param);
    }
}
