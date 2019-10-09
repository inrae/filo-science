<?php

/**
 * ORM of the table probe_measure
 */
class ProbeMeasure extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct(PDO $bdd, array $param = array())
    {
        $this->table = "probe_measure";
        $this->colonnes = array(
            "probe_measure_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "probe_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "parameter_measure_type_id" => array("type" => 1, "requis" => 1),
            "probe_measure_date" => array("type" => 3, "requis" => 1),
            "probe_measure_value" => array("type" => 1, "requis" => 1)
        );
        parent::__construct($bdd, $param);
    }

    /**
     * Get the list of the measures for a probe
     *
     * @param integer $probe_id
     * @param integer $limit
     * @param integer $offset
     * @return array
     */
    function getMeasures(int $probe_id, int $limit = 0, int $offset = 0): array
    {
        /**
         * Get the list of parameters
         */
        $sql = "select distinct parameter from probe_measure
                join parameter_measure_type using (parameter_measure_type_id)
                where probe_measure.probe_id = :id order by 1";
        $params = $this->getListeParamAsPrepared($sql, array("id" => $probe_id));
        if (count($params) > 0) {
            /**
             * Extract the data
             */
            $sql = "select * from crosstab 
                (
                    'select probe_measure_date, parameter, probe_measure_value from probe_measure join parameter_measure_type using (parameter_measure_type_id) where probe_measure.probe_id = $probe_id order by 1',
                    'select distinct parameter from probe_measure join parameter_measure_type using (parameter_measure_type_id) where probe_measure.probe_id = $probe_id order by 1'
                ) AS (date timestamp
                    ";
            foreach ($params as $param) {
                $sql .= ',"' . $param["parameter"] . '" double precision';
            }
            $sql .= " ) order by date desc";
            if ($limit > 0) {
                $sql .= " limit $limit ";
            }
            if ($offset > 0) {
                $sql .= " offset $offset";
            }
            return $this->getListeParam($sql);
        } else {
            return array();
        }
    }
}
