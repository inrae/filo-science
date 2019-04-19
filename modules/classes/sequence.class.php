<?php
/**
 * ORM for the table sequence
 */
class Sequence extends ObjetBDD
{
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
            "date_start" => array("type" => 3),
            "date_end" => array("type" => 3),
            "fishing_duration" => array("type" => 1)
        );
        parent::__construct($bdd, $param);
    }
}
