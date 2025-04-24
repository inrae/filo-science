<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM of table import_column
 */
class ImportColumn extends PpciModel
{

    /**
     * Class constructor.
     */
    public function __construct()
    {
        $this->table = "import_column";
        $this->fields = array(
            "import_column_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "import_description_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "column_order" => array("type" => 1, "requis" => 1),
            "table_column_name" => array("type" => 0)
        );

        parent::__construct();
    }

    /**
     * Get the list of the columns of the table reordering by the number of the column in the 
     * import file
     *
     * @param integer $importDescriptionId
     * @return array
     */
    function getListByColumnNumber(int $importDescriptionId): array
    {
        $data = array();
        $dataRaw = $this->getListFromParent($importDescriptionId);
        foreach ($dataRaw as $value) {
            $data[$value["column_order"]] = $value["table_column_name"];
        }
        return $data;
    }
}
