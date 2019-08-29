<?php

/**
 * ORM of table campaign
 */
class Campaign extends ObjetBDD
{
    private $sql = "select campaign_id, campaign_name, project_id, project_name
    from campaign
    join project using (project_id)";
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "campaign";
        $this->colonnes = array(
            "campaign_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "campaign_name" => array("requis" => 1, "type" => 0),
            "project_id" => array("requis" => 1, "parentAttrib" => 1)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Search all campaigns from search parameters
     *
     * @param array $param
     * @return array
     */
    function getListSearch($param)
    {

        $where = " where ";
        $and = "";
        $values = array();
        if ($param["project_id"] > 0) {
            $where .= $and . " project_id = :project_id";
            $values["project_id"] = $param["project_id"];
            $and = " and ";
        }
        if (strlen($param["is_active"])> 0) {
            $where .= $and." is_active = :is_active";
            $and = " and ";
            $values["is_active"] = $param["is_active"];
        }
        if (strlen($and) > 0) {
            return $this->getListeParamAsPrepared($this->sql . $where, $values);
        } else {
            return array();
        }
    }
    /**
     * Get the detail of a campaign
     *
     * @param int $campaign_id
     * @return array
     */
    function getDetail($campaign_id)
    {
        $where = " where campaign_id = :campaign_id";
        return ($this->lireParamAsPrepared($this->sql . $where, array("campaign_id" => $campaign_id)));
    }
}
