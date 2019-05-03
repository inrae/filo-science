<?php
/**
 * ORM for the table sequence
 */
class Sequence extends ObjetBDD
{
    private $sql = "select sequence_id, sequence_number, s.date_start, s.date_end, fishing_duration
                    , operation_id, operation_name, freshwater
                    ,campaign_id, campaign_name
                    ,project_id, project_name
                    ,protocol_id, measure_default, measure_default_only
                    from sequence s
                    join operation using (operation_id)
                    join campaign using (campaign_id)
                    join project using (project_id)
                    join protocol using (protocol_id)
                    ";
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "sequence";
        $this->colonnes = array(
            "sequence_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "operation_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "sequence_number" => array("requis" => 1),
            "date_start" => array("type" => 3, "defaultValue"=>$this->getDateHeure()),
            "date_end" => array("type" => 3),
            "fishing_duration" => array("type" => 1)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get the new value for sequence_number for a new sequence in a operation
     *
     * @param int $operation_id
     * @return int
     */
    function getLastSequenceNumber($operation_id)
    {
        $newVal = 1;
        $sql = "select max(sequence_number) as sequence_number from sequence where operation_id = :operation_id";
        $data = $this->lireParamAsPrepared($sql, array("operation_id" => $operation_id));
        if ($data["sequence_number"] > 0) {
            $newVal = $data["sequence_number"] + 1;
        }
        return $newVal;
    }
    /**
     * Get the detail of a sequence
     *
     * @param int $sequence_id
     * @return array
     */
    function getDetail($sequence_id) {
        $where = " where sequence_id = :sequence_id";
        return $this->lireParamAsPrepared($this->sql.$where, array("sequence_id"=>$sequence_id));
    }
}
