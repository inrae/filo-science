<?php
/**
 * ORM of the table import_type
 */
class ImportType extends ObjetBDD {
    function __construct($bdd, array $param = array()) {
        $this->table = "import_type";
        $this->colonnes = array(
            "import_type_id"=>array("type"=>1, "requis"=>1, "key"=>1, "defaultValue"=>0),
            "import_type_name"=>array("type"=>0, "requis"=>1),
            "tablename"=>array("type"=>0, "requis"=>1),
            "column_list"=>array("type"=>0, "requis"=>1)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get the list of the columns used by the import, in an array
     *
     * @param integer $id
     * @return array
     */
    function getListColumns(int $id):array {
        $sql = "select column_list from import_type where import_type_id = :id";
        $data = $this->lireParamAsPrepared($sql, array("id"=>$id));
        return (explode(',', $data["column_list"]));
    }
}