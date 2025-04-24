<?php 
namespace App\Models;
use Ppci\Models\PpciModel;
class Operator extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "operator";
        $this->fields = array(
            "operator_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "firstname" => array("type" => 0),
            "name" => array("type" => 0, "requis" => 1),
            "is_active" => array("type" => 1, "defaultValue" => 1),
            "uuid" => array("type" => 0)
        );
        parent::__construct();
    }
    /**
     * Get all active operators rattached or not to an operation
     *
     * @param int $operation_id
     * @param boolean $with_active : get the list of active operators  not rattached to the operation
     * @return array
     */
    function getListFromOperation($operation_id, $with_others_active = true)
    {
        if ($with_others_active) {
            $sql = "SELECT operator_id,
                            firstname,
                            name,
                            is_active,
                            operation_id,
                            is_responsible
                    FROM operator
                    JOIN operation_operator USING (operator_id)
                    WHERE operation_id = :operation_id
                    UNION
                    SELECT operator_id,
                            firstname,
                            name,
                            is_active,
                            NULL AS operation_id,
                            FALSE AS is_responsible
                    FROM operator
                    WHERE operator_id NOT IN (SELECT operator_id
                                            FROM operation_operator
                                            WHERE operation_id = :operation_id)
                    AND   is_active = TRUE
                    ";
        } else {
            $sql = "SELECT operator_id, firstname, name, is_active, operation_id, is_responsible
                from operator
                join operation_operator using (operator_id)
                where operation_id = :operation_id:";
        }
        return $this->getListeParamAsPrepared($sql, array("operation_id" => $operation_id));
    }
    /**
     * Set operators attached to an operation
     *
     * @param int $operation_id
     * @param array $operators
     * @param int $operator_responsible
     * @return void
     */
    function setOperatorsToOperation($operation_id, $operators, $operator_responsible)
    {
        /**
         * Delete pre-existant data
         */
        $sql = "delete from operation_operator
                where operation_id = :operation_id:";
        $this->executeAsPrepared($sql, array("operation_id" => $operation_id), true);
        foreach ($operators as $value) {
            $data = array(
                "operation_id" => $operation_id,
                "operator_id" => $value
            );
            if ($value == $operator_responsible) {
                $data["is_responsible"] = 1;
            } else {
                $data["is_responsible"] = 0;
            }
            $sql = "insert into operation_operator (operation_id, operator_id, is_responsible)
                    values (:operation_id:, :operator_id:, :is_responsible:)";
            $this->executeAsPrepared($sql, $data);
        }
    }
}
