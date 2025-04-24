<?php 
namespace App\Models;
use Ppci\Models\PpciModel;

/**
 * ORM of the table protocol
 */
class Protocol extends PpciModel
{

    /**
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "protocol";
        $this->fields = array(
            "protocol_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "protocol_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "protocol_url" => array("type" => 0),
            "protocol_description" => array("type" => 0),
            "measure_default" => array('type' => 0, "requis" => 1),
            "measure_default_only" => array("type" => 1, "requis" => 1),
            "analysis_template_id" => array("type" => 1),
            "existing_taxon_only" => array("type" => 1, "requis" => 1, "defaultValue" => 1),
            "ambience_template_id" => array("type"=>1)
        );
        parent::__construct();
    }

    /**
     * Return the list of the protocols
     *
     * @return array
     */
    function getListProtocol()
    {
        $sql = "select protocol_id, protocol_name, protocol_url, protocol_description
        ,measure_default, measure_default_only, existing_taxon_only
        ,analysis_template_id, analysis_template_name
        ,ambience_template_id, ambience_template_name
        from protocol
        left outer join analysis_template using (analysis_template_id)
        left outer join ambience_template using (ambience_template_id)
        order by protocol_name";
        return $this->getListeParam($sql);
    }

    /**
     * Get the detail of a protocol with attached analysis_template
     *
     * @param int $protocol_id
     * @return array
     */
    function getDetail($protocol_id)
    {
        $sql = "select protocol_id, protocol_name, protocol_url, protocol_description
                , measure_default, measure_default_only, existing_taxon_only
                ,analysis_template_id, analysis_template_name, analysis_template_schema
                ,ambience_template_id, ambience_template_name, ambience_template_schema
                from protocol
                left outer join analysis_template using (analysis_template_id)
                left outer join ambience_template using (ambience_template_id)
                where protocol_id = :protocol_id";
        return $this->lireParamAsPrepared($sql, array("protocol_id" => $protocol_id));
    }

    /**
     * Get the measure_template_schema from protocol and taxon
     *
     * @param int $protocol_id
     * @param int $taxon_id
     * @return string
     */
    function getTaxonTemplate($protocol_id, $taxon_id)
    {
        $sql = "select measure_template_schema
                from measure_template
                join protocol_measure using (measure_template_id)
                where protocol_id = :protocol_id and taxon_id = :taxon_id";
        $data = $this->lireParamAsPrepared($sql, array("protocol_id" => $protocol_id, "taxon_id" => $taxon_id));
        return ($data["measure_template_schema"]);
    }
}
