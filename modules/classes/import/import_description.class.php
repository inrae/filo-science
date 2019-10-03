<?php

/**
 * ORM of table import_description
 */
class ImportDescription extends ObjetBDD
{
    private $sql = "select import_description_id, import_type_id, csv_type_id
                    ,import_description_name, separator
                    ,csv_type_name, import_type_name, tablename, column_list, is_table_er
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
            "separator" => array("type" => 0, "requis" => 1)
        );

        parent::__construct($bdd, $param);
    }
    /**
     * Get the list of the templates
     *
     * @param string $order
     * @return array
     */
    public function getListe($order = "")
    {
        strlen($order) > 0 ? $orderby = " order by $order" : $orderby = "";
        return $this->getListeParam($this->sql . $orderby);
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

    /**
     * Delete a record with children
     *
     * @param int $id
     * @return array
     */
    public function supprimer(int $id)
    {
        include_once "modules/classes/import_function.class.php";
        $function = new ImportFunction($this->connection);
        $function->supprimerChamp($id, "import_description_id");
        include_once "modules/classes/import_column.class.php";
        $column = new ImportColumn($this->connection);
        $column->supprimerChamp($id, "import_description_id");
        return parent::supprimer($id);
    }
}
