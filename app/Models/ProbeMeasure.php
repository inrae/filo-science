<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM of the table probe_measure
 */
class ProbeMeasure extends PpciModel
{
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "probe_measure";
        $this->fields = array(
            "probe_measure_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "probe_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "parameter_measure_type_id" => array("type" => 1, "requis" => 1),
            "probe_measure_date" => array("type" => 3, "requis" => 1),
            "probe_measure_value" => array("type" => 1, "requis" => 1)
        );
        parent::__construct();
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
        $sql = "SELECT distinct parameter from probe_measure
                join parameter_measure_type using (parameter_measure_type_id)
                where probe_measure.probe_id = :id: order by 1";
        $params = $this->getListeParamAsPrepared($sql, array("id" => $probe_id));
        if (count($params) > 0) {
            /**
             * Extract the data
             */
            $sql = "SELECT * from crosstab
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
    /**
     * Import data from file
     *
     * @param array $data
     * @param boolean $rewriteMode
     * @return void
     */
    function importData(array $data, bool $rewriteMode = false)
    {
        if ($rewriteMode) {
            $sql = "SELECT probe_measure_id from probe_measure where probe_id = :probe_id:
              and parameter_measure_type_id = :parameter_measure_type_id: and probe_measure_date = :probe_measure_date:";
            $databefore = $this->lireParamAsPrepared($sql, array(
                "probe_id" => $data["probe_id"],
                "parameter_measure_type_id" => $data["parameter_measure_type_id"],
                "probe_measure_date" => $data["probe_measure_date"]
            ));
            if ($databefore["probe_measure_id"] > 0) {
                $data["probe_measure_id"] = $databefore["probe_measure_id"];
            }
        }
        return parent::write($data);
    }
}
