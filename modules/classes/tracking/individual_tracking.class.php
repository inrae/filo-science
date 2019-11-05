<?php

/**
 * individual_tracking ORM class
 */
class IndividualTracking extends ObjetBDD
{
    private $sql = "select individual_id, release_station_id, transmitter_type_id, it.project_id, taxon_id
                    ,tag, transmitter
                    , transmitter_type_name
                    ,project_name
                    ,scientific_name
                    ,uuid
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
            "taxon_id" => array("type" => 1, "requis" => 1)
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
    function getListFromProject(int $project_id)
    {
        $where = " where it.project_id = :project_id";
        return ($this->getListeParamAsPrepared($this->sql . $where, array("project_id" => $project_id)));
    }

    /**
     * Get the fish from the tag
     *
     * @param string $tag
     * @return array
     */
    function getFromTag(string $tag)
    {
        $where = " where tag = :tag";
        return $this->lireParamAsPrepared($this->sql . $where, array("tag" => $tag));
    }
    /**
     * Get the fish from the transmitter
     *
     * @param string $transmitter
     * @return void
     */
    function getFromTransmitter(string $transmitter)
    {
        $where = " where transmitter = :transmitter";
        return $this->lireParamAsPrepared($this->sql . $where, array("transmitter" => $transmitter));
    }

    /**
     * Delete a tracking fish with children
     *
     * @param integer $id
     * @return void
     */
    function supprimer(int $id)
    {
        include_once "modules/classes/tracking/detection.class.php";
        $detection = new Detection($this->connection, $this->paramori);
        $detection->supprimerChamp($id, "individual_id");
        parent::supprimer($id);
    }

    /**
     * Get the detail of a fish
     *
     * @param integer $id
     * @return array
     */
    function getDetail(int $id)
    {
        $where = " where individual_id = :individual_id";
        return $this->lireParamAsPrepared($this->sql . $where, array("individual_id" => $id));
    }

    /**
     * REturn all detections for an individual
     *
     * @param integer $id
     * @param string $formatDate
     * @param string $orderBy
     * @return array
     */
    function getListDetection(int $id, string $formatDate = 'YYYY-MM-DD HH24:MI:SS.MS', string $orderBy = "") :array {
        $data = array();
        $sql = "
                select detection_id as id, individual_id, to_char(detection_date, :formatDate) as detection_date
                    , nb_events, duration, validity, signal_force, observation
                    ,station_long long, station_lat lat, station_name
                    ,'stationary' as detection_type
                from detection
                join antenna using (antenna_id)
                join station using (station_id)
                where individual_id = :id
                union
                select location_id as id, individual_id, to_char(detection_date, :formatDate) as detection_date
                    , null nb_events, null duration, true validity, signal_force, observation
                    , location_long, location_lat, null station_name
                    ,'mobile' as detection_type
                from location 
                where individual_id = :id
        ";
        if (strlen ($orderBy)> 0) {
            $sql = "with req as (".$sql.") select * from req order by $orderBy";
        }
        $data = $this->getListeParamAsPrepared($sql, array("id"=>$id, "formatDate"=>$formatDate));
        return $data;
    }
}
