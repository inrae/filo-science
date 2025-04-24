<?php 
namespace App\Models;
use Ppci\Models\PpciModel;

/**
 * Generic class for all parameters tables with only 2 fields:
 * table name: test
 * field id: test_id
 * field name : field_name
 */
class Param extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param string $tablename
     */
    function __construct($bdd, $tablename)
    {
        $this->table = $tablename;
        $this->fields = array(
            $tablename . "_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            $tablename . "_name" => array("type" => 0, "requis" => 1),
            $tablename . "_code" => array("type" => 0)
        );
        parent::__construct();
    }
    /**
     * Get the id of a record from the name
     *
     * @param string $name
     * @param boolean $withCreate: if true and the record not exists, the parameter is created
     * @return int
     */
    function getIdFromName($name, $withCreate = false)
    {
        if (!empty($name)) {
            $sql = "select " . $this->table . "_id  as id
                from $this->table
                where " . $this->table . "_name = :name";
            $data = $this->lireParamAsPrepared($sql, array("name" => $name));
            if ($withCreate && !$data["id"]) {
                $data["id"] = $this->ecrire(array($this->table . "_name" => $name));
            }
            return $data["id"];
        }
    }
}
