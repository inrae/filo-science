<?php
/**
 * ORM of the table ambience_template
 */
class AmbienceTemplate extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "ambience_template";
        $this->colonnes = array(
            "ambience_template_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "ambience_template_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "ambience_template_schema" => array("type"=>0)
        );
        parent::__construct($bdd, $param);
    }
}