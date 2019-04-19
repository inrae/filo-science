<?php
/**
 * ORM for table operation
 */
class Operation extends ObjetBDD
{
    private $sql = "select o.*
                    ,campaign_name
                    , station_name
                    , protocol_name, measure_default, measure_default_only
                    ,water_regime_name, fishing_strategy_name
                    ,scale_id
                    , taxa_template_name, taxa_model
                    from operation o
                    join campaign using (campaign_id)
                    left outer join station using (station_id)
                    left outer join protocol using (protocol_id)
                    left outer join water_regime using (water_regime_id)
                    left outer join fishing_strategy using (fishing_strategy_id)
                    left outer join scale using (scale_id)
                    left outer join taxa_template using (taxa_template_id)
                    ";
    /**
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "operation";
        $this->colonnes = array(
            "operation_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "campaign_id" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "operation_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "date_start" => array("type" => 3, "requis" => 1, "defaultValue" => $this->getDateHeure()),
            "date_end" => array("type" => 3),
            "freshwater" => array("type" => 1, "defaultValue" => 1, "requis" => 1),
            "long_start" => array("type" => 1),
            "long_end" => array("type" => 1),
            "lat_start" => array("type" => 1),
            "lat_end" => array("type" => 1),
            "pk_source" => array("type" => 1),
            "pk_mouth" => array("type" => 1),
            "length" => array("type" => 1),
            "side" => array("type" => 0),
            "altitude" => array("type" => 1),
            "tidal_coef" => array("type" => 1),
            "debit" => array("type" => 1),
            "surface" => array("type" => 1),
            "station_id" => array("type" => 1),
            "protocol_id" => array("type" => 1),
            "water_regime_id" => array("type" => 1),
            "fishing_strategy_id" => array("type" => 1),
            "scale_id" => array("type" => 1),
            "taxa_template_id" => array("type" => 1)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Overload of lire for insert campaign_name
     *
     * @param int $id
     * @param boolean $getDefault
     * @param integer $parent_id
     * @return array
     */
    function lire($id, $getDefault = true, $parent_id = 0)
    {
        $data = parent::lire($id, $getDefault, $parent_id);
        /* Recovery of campaign_name */
        $sql = "select campaign_name from campaign where campaign_id = :campaign_id";
        $dcamp = $this->lireParamAsPrepared($sql, array("campaign_id" => $data["campaign_id"]));
        $data["campaign_name"] = $dcamp["campaign_name"];
        return $data;
    }

    /**
     * Get list of operation from a campaign
     *
     * @param int $campaign_id
     * @return array
     */
    function getListFromCampaign($campaign_id)
    {
        $where = " where campaign_id = :campaign_id";
        return $this->getListeParamAsPrepared($this->sql . $where, array("campaign_id" => $campaign_id));
    }
    /**
     * Get the content of an operation with related tables
     *
     * @param int $operation_id
     * @return array
     */
    function getDetail($operation_id)
    {
        $where = " where operation_id = :operation_id";
        return $this->lireParamAsPrepared($this->sql . $where, array("operation_id" => $operation_id));
    }
}
