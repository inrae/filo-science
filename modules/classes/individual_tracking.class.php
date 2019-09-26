<?php

/**
 * individual_tracking ORM class
 */
class IndividualTracking extends ObjetBDD
{
    private $sql = "select individual_id, release_station_id, transmitter_type_id, it.project_id, taxon_id
                    ,tag
                    , transmitter_type_name
                    ,project_name
                    ,scientific_name
                    from individual_tracking it
                    join individual using (individual_id)
                    join project p on (it.project_id = p.project_id)
                    join taxon using (taxon_id)
                    left outer join transmitter_type using (transmitter_type_id)
                    left outer join station_tracking on (station_id = release_station_id)
                    left outer join station using (station_id)";
    /**
     * Constructor
     *
     * @param PDO $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "individual_tracking";
        $this->colonnes = array(
            "individual_id" => array("type" => 1, "requis" => 1, "key" => 1),
            "release_station_id" => array("type" => 1),
            "transmitter_type_id" => array("type" => 1),
            "project_id" => array("type" => 1, "requis" => 1),
            "taxon_id" => array("type"=>1, "requis"=>1)
        );
        $this->id_auto = 0;
        parent::__construct($bdd, $param);
    }
    /**
     * Get the list of individuals from project
     *
     * @param integer $project_id
     * @return array
     */
    function getListFromProject(int $project_id) {
        $where = " where it.project_id = :project_id";
        return ($this->getListeParamAsPrepared($this->sql.$where, array("project_id"=>$project_id)));
    }
}
