<?php 
namespace App\Models;
use Ppci\Models\PpciModel;
class TaxaTemplate extends PpciModel
{
function __construct()
    {
        $this->table = "taxa_template";
        $this->fields = array(
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
                "requis"=>1,
                "defaultValue"=>1
            ),
            "taxa_model"=>array(
                "type"=>0
            )
        );
        parent::__construct();
    }
}