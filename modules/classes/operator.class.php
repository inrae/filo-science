<?php
class Operator extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "operator";
        $this->colonnes = array(
            "operator_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "firstname" => array("type" => 0),
            "name" => array("type" => 0, "requis" => 1),
            "is_active" => array("type" => 1, "defaultValue" => 1)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get all active operators rattached or not to an operation
     *
     * @param int $operation_id
     * @param boolean $with_active : get the list of active operators  not rattached to the operation
     * @return array
     */
    function getListFromOperation($operation_id, $with_active = true)
    {
        $sql = "select operator_id, firstname, name, is_active, operation_id, is_responsible
                from operator
                join operation_operator using (operator_id)
                where operation_id = :operation_id";
        $data = $this->getListeParamAsPrepared($sql, array("operation_id" => $operation_id));
        if ($with_active) {
            $sql = "select distinct operator_id, firstname, name, is_active, 
                    null as operation_id, false as is_responsible
                    from operator
                    left outer join (operation_operator using (operator_id)
                    where operation_id <> :operation_id
                    and is_active = true";
            $data = array_merge($data, $this->getListeParamAsPrepared($sql, array("operation_id" => $operation_id)));
        }
        return $data;
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
                where operation_id = :operation_id";
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
                    values (:operation_id, :operator_id, :is_responsible)";
            $this->executeAsPrepared($sql, $data);
        }
    }
}
