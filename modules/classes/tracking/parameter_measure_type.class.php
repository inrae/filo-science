<?php
/**
 * ORM of table parameter_measure_type
 */
class ParameterMeasureType extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct(PDO $bdd, $param = array())
    {
        $this->table = "parameter_measure_type";
        $this->colonnes = array(
            "parameter_measure_type_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "parameter" => array("type" => 0, "requis" => 1),
            "unit" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
}