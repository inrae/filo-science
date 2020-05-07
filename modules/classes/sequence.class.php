<?php
/**
 * ORM for the table sequence
 */
class Sequence extends ObjetBDD
{
    private $sql = "select sequence_id, sequence_number, s.date_start, s.date_end, fishing_duration
                    , operation.operation_id, operation_name, freshwater, long_start, lat_start, long_end, lat_end, taxa_template_id
                    ,sequence_id as sequence_uid
                    ,campaign_id, campaign_name
                    ,project_id, project_name
                    ,protocol_id, measure_default, measure_default_only
                    , analysis_template_id, existing_taxon_only
                    ,ambience_long, ambience_lat
                    ,ambience_template_id
                    from sequence s
                    join operation using (operation_id)
                    join campaign using (campaign_id)
                    join project using (project_id)
                    join protocol using (protocol_id)
                    left outer join ambience a using (sequence_id)
                    ";
    private $ambience, $analysis, $sequenceGear, $sequencePoint, $sample;
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
            include_once 'modules/classes/sequence_point.class.php';
            $this->analysis = new Analysis($this->connection);
            $this->sequenceGear = new SequenceGear($this->connection);
            $this->sequencePoint = new SequencePoint($this->connection);
            $this->ambience = new Ambience($this->connection);
            $this->sample = new Sample($this->connection);
        }
        $this->analysis->supprimerChamp($id, "sequence_id");
        $this->ambience->supprimerChamp($id, "sequence_id");
        $this->sequenceGear->supprimerChamp($id, "sequence_id");
        $this->sequencePoint->supprimerChamp($id, "sequence_id");
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

    /**
     * Duplicate a sequence associated with an operation
     * and the children ambience and sequence_gear
     *
     * @param integer $id
     * @param integer $operation_id: new operation_id
     * @return void
     */
    function duplicate(int $id, int $operation_id)
    {
        if ($id > 0 && $operation_id > 0) {
            $newid = 0;
            $data = $this->lire($id);
            if ($data["sequence_id"] > 0) {
                foreach (array("date_end", "fishing_duration", "uuid") as $field) {
                    $data[$field] = "";
                }
                $data["date_start"] = $this->getDateHeure();
                $data["sequence_id"] = 0;
                $data["operation_id"] = $operation_id;
                $newid = $this->ecrire($data);
                if ($newid > 0) {
                    /**
                     * Duplicate the ambience (sequence)
                     */
                    include_once "modules/classes/ambience.class.php";
                    $ambience = new Ambience($this->connection, $this->paramori);
                    $dambience = $ambience->getFromSequence($id);
                    if ($dambience["ambience_id"] > 0) {
                        $dambience["ambience_id"] = 0;
                        $dambience["sequence_id"] = $newid;
                        foreach (array("speed_id", "current_speed", "current_speed_min", "current_speed_max", "water_heigh", "water_height_min", "water_height_max", "flow_trend_id", "turbidity_id", "uuid") as $field) {
                            $dambience[$field] = "";
                        }
                        $ambience->ecrire($dambience);
                    }
                    /**
                     * Duplicate the gears
                     */
                    include_once "modules/classes/sequence_gear.class.php";
                    $sequenceGear = new SequenceGear($this->connection, $this->paramori);
                    foreach ($sequenceGear->getListFromParent($id) as $row) {
                        $row["uuid"] = "";
                        $row["sequence_gear_id"] = 0;
                        $row["sequence_id"] = $newid;
                        $sequenceGear->ecrire($row);
                    }
                }
            } else {
                throw new ObjetBDDException(_("Impossible de lire la séquence à dupliquer"));
            }
        } else {
            throw new ObjetBDDException(_("La sequence à dupliquer n'existe pas ou l'opération de rattachement n'est pas indiquée"));
        }
    }

    function getListFromOperation($id) {
        if ($id > 0) {
            $where = " where operation.operation_id = :id";
            return $this->getListeParamAsPrepared($this->sql.$where, array ("id"=>$id));
        }
    }
}
