<?php
class Ambience extends ObjetBDD
{

    private $sql = "select a.*
                    ,o.operation_name, sequence_number
                    
                    ,speed_name, shady_name, clogging_name, facies_name, sinuosity_name
                    ,localisation_name, turbidity_name, situation_name, flow_trend_name
                    ,vegetation_name
                    ,c1.cache_abundance_name as herbarium_cache_abundance
                    ,c2.cache_abundance_name as branch_cache_abundance
                    ,c3.cache_abundance_name as vegetation_cache_abundance
                    ,c4.cache_abundance_name as subbank_cache_abundance
                    ,c5.cache_abundance_name as granulometry_cache_abundance                   
                    ,g1.granulometry_name as dominant_granulometry
                    ,g2.granulometry_name as secondary_granulometry
                    from ambience a
                    left outer join operation o on (o.operation_id = a.operation_id)
                    left outer join sequence using (sequence_id)
                    left outer join speed using (speed_id)
                    left outer join shady using (shady_id)
                    left outer join clogging using (clogging_id)
                    left outer join facies using (facies_id)
                    left outer join sinuosity using (sinuosity_id)
                    left outer join localisation using (localisation_id)
                    left outer join turbidity using (turbidity_id)
                    left outer join situation using (situation_id)
                    left outer join flow_trend using (flow_trend_id)
                    left outer join vegetation using (vegetation_id)
                    left outer join cache_abundance c1 on (herbarium_cache_abundance_id = c1.cache_abundance_id)
                    left outer join cache_abundance c2 on (branch_cache_abundance_id = c2.cache_abundance_id)
                    left outer join cache_abundance c3 on (vegetation_cache_abundance_id = c3.cache_abundance_id)
                    left outer join cache_abundance c4 on (subbank_cache_abundance_id = c4.cache_abundance_id)
                    left outer join cache_abundance c5 on (granulometry_cache_abundance_id = c5.cache_abundance_id)
                    left outer join granulometry g1 on (dominant_granulometry_id = g1.granulometry_id)
                    left outer join granulometry g2 on (secondary_granulometry_id = g2.granulometry_id)
                    
                    ";
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "ambience";
        $this->colonnes = array(
            "ambience_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "ambience_name" => array("type" => 0),
            "operation_id" => array("type" => 1),
            "sequence_id" => array("type" => 1),
            "ambience_length" => array("type" => 1),
            "ambience_width" => array("type" => 1),
            "ambience_depth" => array("type" => 1),
            "ambience_comment" => array("type" => 0),
            "ambience_long" => array("type" => 1),
            "ambience_lat" => array("type" => 1),
            "current_speed" => array("type" => 1),
            "current_speed_max" => array("type" => 1),
            "current_speed_min" => array("type" => 1),
            "water_height" => array("type" => 1),
            "water_height_max" => array("type" => 1),
            "water_height_min" => array("type" => 1),
            "facies_id" => array("type" => 1),
            "situation_id" => array("type" => 1),
            "speed_id" => array("type" => 1),
            "shady_id" => array("type" => 1),
            "localisation_id" => array("type" => 1),
            "vegetation_id" => array("type" => 1),
            "dominant_granulometry_id" => array("type" => 1),
            "secondary_granulometry_id" => array("type" => 1),
            "herbarium_cache_abundance_id" => array("type" => 1),
            "branch_cache_abundance_id" => array("type" => 1),
            "vegetation_cache_abundance_id" => array("type" => 1),
            "subbank_cache_abundance_id" => array("type" => 1),
            "granulometry_cache_abundance_id" => array("type" => 1),
            "clogging_id" => array("type" => 1),
            "sinuosity_id" => array("type" => 1),
            "flow_trend_id" => array("type" => 1),
            "turbidity_id" => array("type" => 1),

        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get the ambience attached at operation
     *
     * @param int $operation_id
     * @return array
     */
    function getFromOperation($operation_id)
    {
        $where = " where o.operation_id = :id";
        return $this->lireParamAsPrepared($this->sql . $where, array("id" => $operation_id));
    }
    /**
     * Get the ambience attached at sequence
     *
     * @param int $sequence_id
     * @return array
     */
    function getFromSequence($sequence_id)
    {
        $where = " where sequence_id = :id";
        return $this->lireParamAsPrepared($this->sql . $where, array("id" => $sequence_id));
    }
}
