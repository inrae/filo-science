<?php 
namespace App\Models;
use Ppci\Models\PpciModel;

/**
 * transmitter_type ORM class
 */
class TransmitterType extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "transmitter_type";
        $this->fields = array(
            "transmitter_type_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "transmitter_type_name" => array("type" => 0, "requis" => 1),
            "characteristics" => array("type" => 0),
            "technology" => array("type" => 0)
        );
        parent::__construct();
    }
}
