<?php

/**
 * ORM for the table sequence
 */
class Sequence extends ObjetBDD
{
    private $sql = "select sequence_id, sequence_number, s.date_start, s.date_end, fishing_duration
                    , operation_id, operation_name, freshwater, long_start, lat_start, long_end, lat_end, taxa_template_id
                    ,sequence_id as sequence_uid
                    ,campaign_id, campaign_name
                    ,project_id, project_name
                    ,protocol_id, measure_default, measure_default_only, analysis_template_id
                    from sequence s
                    join operation using (operation_id)
                    join campaign using (campaign_id)
                    join project using (project_id)
                    join protocol using (protocol_id)
                    ";
    private $ambience, $analysis, $sequenceGear, $sample;
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param array $param
     */
    function __construct($bdd, $param = array())
    {
        $this->table = "sequence";
        $this->colonnes = array(
            "sequence_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "operation_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
            "sequence_number" => array("requis" => 1),
            "date_start" => array("type" => 3, "defaultValue" => $this->getDateHeure()),
            "date_end" => array("type" => 3),
            "fishing_duration" => array("type" => 1),
            "uuid" => array("type" => 0)
        );
        parent::__construct($bdd, $param);
    }
    /**
     * Get the new value for sequence_number for a new sequence in a operation
     *
     * @param int $operation_id
     * @return int
     */
    function getLastSequenceNumber($operation_id)
    {
        $newVal = 1;
        $sql = "select max(sequence_number) as sequence_number from sequence where operation_id = :operation_id";
        $data = $this->lireParamAsPrepared($sql, array("operation_id" => $operation_id));
        if ($data["sequence_number"] > 0) {
            $newVal = $data["sequence_number"] + 1;
        }
        return $newVal;
    }
    /**
     * Get the detail of a sequence
     *
     * @param int $sequence_id
     * @return array
     */
    function getDetail($sequence_id)
    {
        $where = " where sequence_id = :sequence_id";
        return $this->lireParamAsPrepared($this->sql . $where, array("sequence_id" => $sequence_id));
    }
    /**
     * Get the project of a sequence, using the real key
     *
     * @param int $uid
     * @return int
     */
    function getProject($uid)
    {
        $sql = "select project_id
                from sequence
                join operation using (operation_id)
                join campaign using (campaign_id)
                where sequence_id = :id";
        $res = $this->lireParamAsPrepared($sql, array("id" => $uid));
        return ($res["project_id"]);
    }
    /**
     * Test if a sequence is granted
     *
     * @param array $projects: list of granted projects
     * @param int $uid
     * @return boolean
     */
    function isGranted(array $projects, $uid)
    {
        $project_id = $this->getProject($uid);
        $retour = false;
        foreach ($projects as $project) {
            if ($project["project_id"] == $project_id) {
                $retour = true;
                break;
            }
        }
        return $retour;
    }

    function supprimer($id)
    {
        if (!isset($this->ambience)) {
            include_once 'modules/classes/analysis.class.php';
            include_once 'modules/classes/ambience.class.php';
            include_once 'modules/classes/sequence_gear.class.php';
            include_once 'modules/classes/sample.class.php';
            $this->analysis = new Analysis($this->connection);
            $this->sequenceGear = new SequenceGear($this->connection);
            $this->ambience = new Ambience($this->connection);
            $this->sample = new Sample($this->connection);
        }
        $this->analysis->supprimerChamp($id, "sequence_id");
        $this->ambience->supprimerChamp($id, "sequence_id");
        $this->sequenceGear->supprimerChamp($id, "sequence_id");
        /**
         * Get the list of samples
         */
        $samples = $this->sample->getListFromParent($id);
        foreach ($samples as $s) {
            $this->sample->supprimer($s["sample_id"]);
        }
        /**
         * Delete the sequence
         */
        parent::supprimer($id);
    }
}
