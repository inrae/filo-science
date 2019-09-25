<?php
/**
 * ORM of table probe_parameter
 */
class ProbeParameter extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct(PDO $bdd, $param = array())
    {
        $this->table = "probe_parameter";
        $this->colonnes = array(
            "probe_parameter_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "probe_id" => array("type" => 0, "requis" => 1, "parentAttrib" => 1),
            "probe_code" => array("type" => 0, "requis" => 1),
            "parameter" => array("type" => 0, "requis" => 1),
            "unit" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
}
