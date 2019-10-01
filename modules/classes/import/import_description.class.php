<?php

/**
 * ORM of table import_description
 */
class ImportDescription extends ObjetBDD
{

    /**
     * Class constructor.
     */
    public function __construct($bdd, $param = array())
    {
        $this->table = "import_description";
        $this->colonnes = array(
            "import_description_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "import_type_id" => array("type" => 1, "requis" => 1),
            "csv_type_id" => array("type" => 1, "requis" => 1),
            "import_description_name" => array("type" => 0, "requis" => 1),
            "separator" => array("type" => 0, "requis" => 1),
            "is_table_er" => array("type" => 1, "requis" => 1, "defaultValue" => 0)
        );

        parent::__construct($bdd, $param);
    }
}
