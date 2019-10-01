<?php

/**
 * ORM of table import_description
 */
class ImportDescription extends ObjetBDD
{
    private $sql = "select import_description_id, import_type_id, csv_type_id
                    ,import_description_name, separator
                    ,csv_type_name, import_type_name
                    from import_description
                    join import_type using (import_type_id)
                    join csv_type using (csv_type_id)";
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
            /*"is_table_er" => array("type" => 1, "requis" => 1, "defaultValue" => 0)*/
        );

        parent::__construct($bdd, $param);
    }
    /**
     * Get the detail of record
     *
     * @param integer $id
     * @return array
     */
    function getDetail(int $id)
    {
        $where = " where import_description_id = :id";
        return $this->lireParamAsPrepared($this->sql . $where, array("id" => $id));
    }
}
