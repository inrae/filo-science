<?
/**
 * ORM of the table measure_template
 */
class Measure_template extends ObjetBDD
{

    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "measure_template";
        $this->colonnes = array(
            "measure_template_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "measure_template_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "measure_template_value" => array("type" => 0),
            "taxon_id" => array("type" => 1, "requis" => 1)
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Get the list of measures templates attached at a protocol
     *
     * @param integer $protocol_id
     * @return void
     */
    function getListFromProtocol($protocol_id)
    {
        $sql = "select measure_template_id, measure_template_name
                , taxon_id, scientific_name, common_name, fresh_code, sea_code
                from protocol_measure
                join measure_template using(measure_template_id)
                join taxon using (taxon_id)
                where protocol_id = :protocol_id
                order by measure_template_name";
        return $this->getListeParamAsPrepared($sql, array("protocol_id" => $protocol_id));
    }
}
