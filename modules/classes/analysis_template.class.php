<?php
/**
 * ORM of the table analyse_template
 */
class AnalysisTemplate extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "analysis_template";
        $this->colonnes = array(
            "analysis_template_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "analysis_template_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "analysis_template_schema" => array("type"=>0)
        );
        parent::__construct($bdd, $param);
    }
}