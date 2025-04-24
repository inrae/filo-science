<?php

namespace App\Models;

use Ppci\Models\PpciModel;

/**
 * ORM of the table measure_template
 */
class MeasureTemplate extends PpciModel
{

    /**
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "measure_template";
        $this->fields = array(
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
            "measure_template_schema" => array("type" => 0),
            "taxon_id" => array("type" => 1, "requis" => 1)
        );
        parent::__construct();
    }

    /**
     * Get the list of measures templates attached at a protocol
     *
     * @param integer $protocol_id
     * @return void
     */
    function getListFromProtocol($protocol_id)
    {
        $sql = "SELECT measure_template_id, measure_template_name
                , taxon_id, scientific_name, common_name
                from protocol_measure
                join measure_template using(measure_template_id)
                join taxon using (taxon_id)
                where protocol_id = :protocol_id:
                order by measure_template_name";
        return $this->getListeParamAsPrepared($sql, array("protocol_id" => $protocol_id));
    }
    /**
     * get all the templates, associated or no to a protocol
     *
     * @param [type] $protocol_id
     * @return void
     */
    function getTotalListForProtocol($protocol_id)
    {
        $sql = "SELECT m. measure_template_id, m.measure_template_name,
                taxon_id, scientific_name, common_name
                , protocol_id
                from measure_template m
                join taxon using (taxon_id)
                left outer join protocol_measure p on (m.measure_template_id = p.measure_template_id and p.protocol_id = :protocol_id:)
                order by measure_template_name";
        return $this->getListeParamAsPrepared($sql, array("protocol_id" => $protocol_id));
    }

    /**
     * Add the data of taxon to the default function
     *
     * @param int $id
     * @param integer $parentValue
     * @return array
     */
    function read(int $id, bool $getDefault = true, $parentValue = 0): array
    {
        if ($id == 0) {
            return $this->getDefaultValue($parentValue);
        } else {
            $sql = "SELECT measure_template_id, measure_template_name, measure_template_schema
                    , taxon_id, scientific_name, common_name
                    from measure_template
                    join taxon using (taxon_id)
                    where measure_template_id = :id:";
            return $this->lireParamAsPrepared($sql, array("id" => $id));
        }
    }

    /**
     * rewriting getliste for get the taxon
     *
     * @param string $order
     * @return array
     */
    function getListe($order = ""): array
    {
        $sql = "SELECT measure_template_id, measure_template_name, measure_template_schema,
                taxon_id, scientific_name
                from measure_template
                join taxon using(taxon_id)";
        if (!empty($order)) {
            $sql .= " order by " . $order;
        }
        return ($this->getListeParam($sql));
    }
}
