<?php 
namespace App\Models;
use Ppci\Models\PpciModel;
class SequenceGear extends PpciModel
{
    private $sql = "select sequence_gear_id, voltage, amperage, gear_nb, depth
                    ,sequence_id ,sequence_name
                    ,gear_id, gear_name
                    ,gear_method_id, gear_method_name, business_code
                    ,electric_current_type_id, electric_current_type_name
                    ,operation_id, operation_name, campaign_id, campaign_name
                    from sequence_gear
                    join gear using (gear_id)
                    join sequence using (sequence_id)
                    join operation using (operation_id)
                    join campaign using (campaign_id)
                    left outer join gear_method using (gear_method_id)
                    left outer join electric_current_type using (electric_current_type_id)
                    ";
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "sequence_gear";
        $this->fields = array(
            "sequence_gear_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "sequence_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "gear_id" => array("type" => 1, "requis" => 1),
            "gear_method_id" => array("type" => 1),
            "electric_current_type_id" => array("type" => 1),
            "gear_nb" => array("type" => 1, "requis" => 1, "defaultValue" => 1),
            "voltage" => array("type" => 1),
            "amperage" => array("type" => 1),
            "depth" => array("type" => 1),
            "uuid" => array("type"=>0),
            "business_code"=>array("type"=>0)
        );
        parent::__construct();
    }
    /**
     * Get the list from a sequence
     *
     * @param int $sequence_id
     * @return array
     */
    function getListFromSequence($sequence_id)
    {
        $where = " where sequence_id = :sequence_id";
        return ($this->getListeParamAsPrepared($this->sql . $where, array("sequence_id" => $sequence_id)));
    }
}
