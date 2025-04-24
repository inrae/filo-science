<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM of table import_description
 */
class ImportDescription extends PpciModel
{
    private $sql = "SELECT import_description_id, import_type_id, csv_type_id
                    ,import_description_name, separator, first_line
                    ,csv_type_name, import_type_name, tablename, column_list
                    from import_description
                    join import_type using (import_type_id)
                    join csv_type using (csv_type_id)";
    /**
     * Class constructor.
     */
    public function __construct()
    {
        $this->table = "import_description";
        $this->fields = array(
            "import_description_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "import_type_id" => array("type" => 1, "requis" => 1),
            "csv_type_id" => array("type" => 1, "requis" => 1),
            "import_description_name" => array("type" => 0, "requis" => 1),
            "separator" => array("type" => 0, "requis" => 1),
            "first_line" => array("type" => 1, "defaultValue" => 2, "requis" => 1)
        );

        parent::__construct();
    }
    /**
     * Get the list of the templates
     *
     * @param string $order
     * @return array
     */
    public function getListe($order = ""): array
    {
        !empty($order)  ? $orderby = " order by $order" : $orderby = "";
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
        $where = " where import_description_id = :id:";
        return $this->lireParamAsPrepared($this->sql . $where, array("id" => $id));
    }

    /**
     * Delete a record with children
     *
     * @param int $id
     * @return array
     */
    public function delete($id = null, $purge = false)
    {
        $function = new ImportFunction;
        $function->deleteFromField($id, "import_description_id");
        $column = new ImportColumn;
        $column->deleteFromField($id, "import_description_id");
        return parent::delete($id);
    }
    /**
     * Duplicate an import_description and his children
     *
     * @param integer $id
     * @return int|void
     */
    public function duplicate(int $id)
    {
        $data = $this->lire($id);
        if ($data["import_description_id"] > 0) {
            $data["import_description_id"] = 0;
            $data["import_description_name"] .= " - copy";
            $newId = $this->ecrire($data);
            if ($newId > 0) {
                /**
                 * Prepare the children records
                 */
                $importFunction = new ImportFunction;
                $list = $importFunction->getListFromParent($id);
                foreach ($list as $row) {
                    $row["import_function_id"] = 0;
                    $row["import_description_id"] = $newId;
                    $importFunction->ecrire($row);
                }
                $importColumn = new ImportColumn;
                $list = $importColumn->getListFromParent($id);
                foreach ($list as $row) {
                    $row["import_column_id"] = 0;
                    $row["import_description_id"] = $newId;
                    $importColumn->ecrire($row);
                }
                return $newId;
            }
        }
    }
}
