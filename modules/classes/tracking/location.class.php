<?php
/**
 * ORM of the table location
 */
class Location extends ObjetBDD
{
    private $sridLocation = 4326;
    private $sql = "select location_id, project_id, river_id, antenna_type_id, 
                    location_pk, location_long, location_lat
                    ,antenna_type_name, project_name, river_name
                    from location
                    join project using (project_id)
                    left outer join antenna_type using (antenna_type_id)
                    left outer join river using (river_id)";

    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct(PDO $bdd, array $param = array())
    {
        $this->table = "location";
        $this->colonnes = array(
            "location_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "project_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "individual_id"=>array("type"=>1, "requis"=>1),
            "detection_date" => array("type"=>3, "requis"=>1, "defaultValue"=>"getDateHeure"),
            "river_id" => array("type" => 1),
            "antenna_type_id" => array("type" => 1),
            "location_pk" => array("type" => 1),
            "location_long" => array("type" => 1),
            "location_lat" => array("type" => 1),
            "signal_force" => array("type" => 1),
            "observation" => array("type" => 0),
            "geom" => array("type" => 4)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get the list of the locations attached to a project
     *
     * @param integer $projectId
     * @return array
     */
    function getListFromProject(int $projectId)
    {
        $where = " where project_id = :project_id";
        $order = " order by location_pk, location_id";
        return $this->getListeParamAsPrepared($this->sql . $where . $order, array("project_id" => $projectId));
    }
}
