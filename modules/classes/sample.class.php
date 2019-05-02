<?php
class Sample extends ObjetBDD
{
    private $sql = "select sample_id, sequence_id, taxon_id
                    ,taxon_name, total_number, total_measured, total_weight
                    ,sample_size_min, sample_size_max, sample_comment
                    ,scientific_name, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max
                    ,sequence_number
                    from sample
                    join sequence using (sequence_id)
                    left outer join taxon using (taxon_id)
                    ";
    /**
     * constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "sample";
        $this->colonnes = array(
            "sample_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "sequence_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "taxon_id" => array("type" => 1),
            "sample_name" => array("requis" => 1),
            "sample_number" => array("requis" => 1, "type" => 1),
            "total_measured" => array("type" => 1),
            "total_weight" => array("type" => 1),
            "sample_size_min" => array("type" => 1),
            "sample_size_max" => array("type" => 1),
            "sample_comment" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get the detail of a sample
     *
     * @param int $sample_id
     * @return array
     */
    function getDetail($sample_id)
    {
        $where = " where sample_id = :sample_id";
        return ($this->lireParamAsPrepared($this->sql . $where, array("sample_id" => $sample_id)));
    }
    /**
     * Get the list of samples attached to a sequence
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
