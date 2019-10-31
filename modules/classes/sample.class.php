<?php
class Sample extends ObjetBDD
{
    private $individual;
    private $sql = "select sample_id, sample_id as sample_uid, sequence_id, taxon_id
                    ,taxon_name, total_number, total_measured, total_weight
                    ,sample_size_min, sample_size_max, sample_comment
                    ,scientific_name, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max
                    ,sequence_number
                    ,operation_id
                    ,protocol_id, measure_default, measure_default_only
                    from sample
                    join sequence using (sequence_id)
                    join operation using (operation_id)
                    join protocol using (protocol_id)
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
            "taxon_name" => array("requis" => 1),
            "total_number" => array("requis" => 1, "type" => 1, "defaultValue" => 1),
            "total_measured" => array("type" => 1),
            "total_weight" => array("type" => 1),
            "sample_size_min" => array("type" => 1),
            "sample_size_max" => array("type" => 1),
            "sample_comment" => array("type" => 0),
            "uuid" => array("type" => 0)
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

    /**
     * Recalculate global data from individuals
     *
     * @param int $sample_id
     * @return void
     */
    function setCalculatedData($sample_id)
    {
        /**
         * Get the list of individuals
         */
        $data = $this->getDetail($sample_id);
        require_once 'modules/classes/individual.class.php';
        $ind = new Individual($this->connection, $this->paramori);
        $individuals = $ind->getListFromSample($sample_id);
        $nb = 0;
        $weight = 0;
        $min = 999999;
        $max = 0;
        foreach ($individuals as $individual) {
            $nb++;
            // weight
            if ($individual["weight"] > 0) {
                $weight += $individual["weight"];
            }
            // length
            $length = $individual[$data["measure_default"]];
            if ($length > 0) {
                if ($length < $min) {
                    $min = $length;
                }
                if ($length > $max) {
                    $max = $length;
                }
            }
        }
        $data["total_measured"] = $nb;
        if ($data["total_number"] < $nb) {
            $data["total_number"] = $nb;
        }
        if ($data["total_weight"] < $weight) {
            $data["total_weight"] = $weight;
        }
        if ($min == 999999) {
            $min = 0;
        }
        $data["sample_size_min"] = $min;
        $data["sample_size_max"] = $max;
        $this->ecrire($data);
    }

    /**
     * Rewrite Delete function for delete individuals
     */
    function supprimer($id)
    {
        /**
         * Delete individuals
         */
        if (!isset($this->individual)) {
            require_once 'modules/classes/individual.class.php';
            $this->individual = new Individual($this->connection);
        }
        /**
         * get the list of individuals
         */
        $individuals = $this->individual->getListFromParent($id);
        foreach ($individuals as $ind) {
            $this->individual->deleteFromSample($ind["individual_id"]);
        }
        parent::supprimer($id);
    }
    /**
     * Get the project of a sample, using the real key
     *
     * @param int $uid
     * @return int
     */
    function getProject($uid)
    {
        $sql = "select project_id
                from sample
                join sequence using (sequence_id)
                join operation using (operation_id)
                join campaign using (campaign_id)
                where sample_id = :id";
        $res = $this->lireParamAsPrepared($sql, array("id" => $uid));
        return ($res["project_id"]);
    }
    /**
     * Test if a sample is granted
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
}
