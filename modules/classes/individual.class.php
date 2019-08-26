<?php
/**
 * ORM for the table individual
 */
class Individual extends ObjetBDD
{
    private $sql = "select individual_id, individual_id as individual_uid, sample_id, sexe_id, pathology_id
                    , sl, fl, tl, wd, ot, weight
                    ,other_measure, individual_comment, age
                    ,measure_estimated, pathology_codes, tag, tag_posed
                    ,pathology_name, pathology_code 
                    ,sexe_name, sexe_code
                    ,other_measures
                    from individual 
                    left outer join pathology using (pathology_id)
                    left outer join sexe using (sexe_id)
                    left outer join v_individual_other_measures using (individual_id)
    ";
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "individual";
        $this->colonnes = array(
            "individual_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "sample_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "sexe_id" => array("type" => 1),
            "pathology_id" => array("type" => 1),
            "sl" => array("type" => 1),
            "fl" => array("type" => 1),
            "tl" => array("type" => 1),
            "wd" => array("type" => 1),
            "ot" => array("type" => 1),
            "weight" => array("type" => 1),
            "age" => array("type" => 1),
            "measure_estimated" => array("type" => 1,  "requis" => 1, "defaultValue" => 0),
            "other_measure" => array("type" => 0),
            "individual_comment" => array("type" => 0),
            "pathology_codes" => array("type" => 0),
            "tag" => array("type" => 0),
            "tag_posed" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get the list of individuals attached to a sample
     *
     * @param int $sample_id
     * @return array
     */
    function getListFromSample($sample_id)
    {
        $where = " where sample_id = :sample_id";
        return $this->getListeParamAsPrepared($this->sql . $where, array("sample_id" => $sample_id));
    }
    /**
     * Add the value individual_uid for display individual_id in forms
     *
     * @param int $id
     * @param boolean $getDefault
     * @param string $parentValue
     * @return array
     */
    function lire($id, $getDefault = true, $parentValue = "")
    {
        $data = parent::lire($id, $getDefault, $parentValue);
        if ($data["individual_id"] > 0) {
            $data["individual_uid"] = $data["individual_id"];
        }
        return $data;
    }
}
