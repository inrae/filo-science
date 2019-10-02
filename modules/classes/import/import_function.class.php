<?php

/**
 * ORM of table import_function
 */
class ImportFunction extends ObjetBDD
{
    private $sql = "select import_function_id, import_description_id, function_type_id
                    ,column_number, execution_order, arguments, column_result
                    ,function_name
                    from import_function
                    join function_type using (function_type_id)";
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
            "column_number" => array("type" => 1, "requis" => 1, "defaultValue"=>1),
            "execution_order" => array("type" => 1, "requis" => 1, "defaultValue"=>1),
            "arguments" => array("type" => 0),
            "column_result" => array("type" => 1, "defaultValue"=>1)
        );

        parent::__construct($bdd, $param);
    }
    /**
     * Get the list from the parent
     *
     * @param integer $parentId
     * @param string $order
     * @return array
     */
    function getListFromParent(int $parentId, string $order = "")
    {
        $where = " where import_description_id = :parentId";
        strlen($order) > 0 ? $orderby = " order by $order" : $orderby = "";
        return $this->getListeParamAsPrepared($this->sql . $where . $orderby, array("parentId" => $parentId));
    }
}
