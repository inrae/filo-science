<?php

/**
 * ORM for the table taxon
 */
class Taxon extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "taxon";
        $this->colonnes = array(
            "taxon_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "scientific_name" => array("requis" => 1),
            "author" => array("type" => 0),
            "common_name" => array("type" => 0),
            "taxon_code" => array("type" => 0),
            "fresh_code" => array("type" => 0),
            "sea_code" => array("type" => 0),
            "ecotype" => array("type" => 0),
            "length_max" => array("type" => 1),
            "weight_max" => array("type" => 1)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Search the taxa corresponding to $val
     *
     * @param string $val
     * @return array
     */
    function search($val, $isFreshcode = 0, $noFreshcode = 0)
    {
        $val = strtoupper($this->encodeData($val));
        $sql = "select taxon_id, scientific_name, common_name, fresh_code, sea_code, length_max, weight_max
                from taxon";
        if ( $noFreshcode == 0 && (strlen($val) == 3 || strlen($val) == 4)) {
            /**
             * search only on the code
             */
            $isFreshcode == 1 ? $field = "fresh_code" : $field = "sea_code";
            $where = " where upper($field) = '$val'";
        } else {
            /**
             * Search on the name
             */
            $where = " where upper(scientific_name) like '%" . $val . "%'
                    or upper (common_name) like '%" . $val . "%'";
        }

        $order = " order by scientific_name";
        return $this->getListeParam($sql . $where . $order);
    }
    /**
     * Get the list of all taxons with a mnemonic code
     *
     * @param boolean $freshwater
     * @return array
     */
    function getListCode($freshwater = true)
    {
        $sql = "select taxon_id, scientific_name, ";
        $freshwater ? $field = "fresh_code" : $field = "sea_code";
        $sql .= $field . " as code from taxon where " . $field . " is not null order by code";
        return $this->getListeParam($sql);
    }
    /**
     * Get a taxon from his code
     *
     * @param string $code
     * @param boolean $freshwater
     * @return array
     */
    function getFromCode($code, $freshwater = true)
    {
        $sql = "select taxon_id, scientific_name, ";
        $freshwater ? $field = "fresh_code" : $field = "sea_code";
        $sql .= $field . " as code from taxon where " . $field . " = :code";
        return $this->lireParamAsPrepared($sql, array("code" => $code));
    }
}
