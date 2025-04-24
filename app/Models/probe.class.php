<?php 
namespace App\Models;
use Ppci\Models\PpciModel;

/**
 * ORM of table probe
 */
class Probe extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct(PDO )
    {
        $this->table = "probe";
        $date = new \DateTime();
        $date->add(new DateInterval('P1Y'));
        $this->fields = array(
            "probe_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "station_id" => array("type" => 0, "requis" => 1, "parentAttrib" => 1),
            "probe_code" => array("type" => 0, "requis" => 1),
            "date_from" => array("type" => 2, "defaultValue" => $this->formatDateDBversLocal(date('Y-m-d'))),
            "date_to" => array("type" => 2, "defaultValue" => $this->formatDateDBversLocal($date->format("Y-m-d")))
        );
        parent::__construct();
    }
}
