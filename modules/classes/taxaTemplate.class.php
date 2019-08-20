<?php
class TaxaTemplate extends ObjetBDD
{
function __construct($bdd, $param = array())
    {
        $this->table = "taxa_template";
        $this->colonnes = array(
            "taxa_template_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "taxa_template_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "freshwater" => array(
                "type"=>1,
                "requis"=>1
            ),
            "taxa_model"=>array(
                "type"=>0
            )
        );
        parent::__construct($bdd, $param); 
    }
}