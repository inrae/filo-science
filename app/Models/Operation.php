<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

/**
 * ORM for table operation
 */
class Operation extends PpciModel
{
    private Sequence $sequence;
    private Ambience $ambience;

    private $sql = "SELECT o.*
                    ,operation_id as operation_uid
                    ,campaign_name, c.project_id
                    , station_name, station_code, station_number
                    , protocol_name, measure_default, measure_default_only
                    ,water_regime_name, fishing_strategy_name
                    ,scale_id
                    , taxa_template_name, taxa_model
                    ,ambience_template_id
                    from operation o
                    join campaign c using (campaign_id)
                    left outer join station using (station_id)
                    left outer join protocol using (protocol_id)
                    left outer join water_regime using (water_regime_id)
                    left outer join fishing_strategy using (fishing_strategy_id)
                    left outer join scale using (scale_id)
                    left outer join taxa_template using (taxa_template_id)
                    ";
    /**
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "operation";
        $this->srid = 4326;
        $this->fields = array(
            "operation_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "campaign_id" => array(
                "type" => 1,
                "requis" => 1,
                "parentAttrib" => 1
            ),
            "operation_name" => array(
                "type" => 0,
                "requis" => 1
            ),
            "date_start" => array("type" => 3, "requis" => 1, "defaultValue" => $this->getDateHeure()),
            "date_end" => array("type" => 3),
            "freshwater" => array("type" => 1, "defaultValue" => 1, "requis" => 1),
            "long_start" => array("type" => 1),
            "long_end" => array("type" => 1),
            "lat_start" => array("type" => 1),
            "lat_end" => array("type" => 1),
            "pk_source" => array("type" => 1),
            "pk_mouth" => array("type" => 1),
            "length" => array("type" => 1),
            "side" => array("type" => 0),
            "altitude" => array("type" => 1),
            "tidal_coef" => array("type" => 1),
            "debit" => array("type" => 1),
            "surface" => array("type" => 1),
            "station_id" => array("type" => 1),
            "protocol_id" => array("type" => 1),
            "water_regime_id" => array("type" => 1),
            "fishing_strategy_id" => array("type" => 1),
            "scale_id" => array("type" => 1),
            "taxa_template_id" => array("type" => 1),
            "uuid" => array("type" => 0),
            "operation_geom" => array("type" => 4)
        );
        parent::__construct();
    }
    /**
     * Overload of lire for insert campaign_name
     *
     * @param int $id
     * @param boolean $getDefault
     * @param integer $parent_id
     * @return array
     */
    function read($id, $getDefault = true, $parent_id = 0): array
    {
        $data = parent::read($id, $getDefault, $parent_id);
        /* Recovery of campaign_name */
        $sql = "SELECT campaign_name from campaign where campaign_id = :campaign_id:";
        $dcamp = $this->lireParamAsPrepared($sql, array("campaign_id" => $data["campaign_id"]));
        $data["campaign_name"] = $dcamp["campaign_name"];
        return $data;
    }
    /**
     * Add the generation of the geom multipoint
     *
     * @param array $data
     * @return int
     */
    function write($data): int
    {
        $data["operation_geom"] = "MULTIPOINT(";
        $is_geom = false;
        if (!empty($data["long_start"]) && !empty($data["lat_start"])) {
            $data["operation_geom"] .= "(" . $data["long_start"] . " " . $data["lat_start"] . ")";
            $is_geom = true;
        }
        if (!empty($data["long_end"])  && !empty($data["lat_end"])) {
            if ($is_geom) {
                $data["operation_geom"] .= ",";
            } else {
                $is_geom = true;
            }
            $data["operation_geom"] .= "(" . $data["long_end"] . " " . $data["lat_end"] . ")";
        }
        if ($is_geom) {
            $data["operation_geom"] .= ")";
        } else {
            $data["operation_geom"] = "";
        }
        return parent::write($data);
    }
    /**
     * Get list of operation from a campaign
     *
     * @param int $campaign_id
     * @return array
     */
    function getListFromCampaign($campaign_id)
    {
        $where = " where campaign_id = :campaign_id:";
        return $this->getListeParamAsPrepared($this->sql . $where, array("campaign_id" => $campaign_id));
    }
    /**
     * Get the content of an operation with related tables
     *
     * @param int $operation_id
     * @return array
     */
    function getDetail($operation_id)
    {
        $where = " where operation_id = :operation_id:";
        return $this->lireParamAsPrepared($this->sql . $where, array("operation_id" => $operation_id));
    }
    /**
     * Get the project of an operation, using the real key
     *
     * @param int $uid
     * @return int
     */
    function getProject($uid)
    {
        $sql = "SELECT project_id
                from operation
                join campaign using (campaign_id)
                where operation_id = :id:";
        $res = $this->lireParamAsPrepared($sql, array("id" => $uid));
        return ($res["project_id"]);
    }
    /**
     * Test if an operation is granted
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
    /**
     * Delete a sequence and all children
     *
     * @param int $id
     * @return void
     */
    function delete($id = null, $purge = false)
    {
        if (!isset($this->ambience)) {
            $this->ambience = new Ambience;
            $this->sequence = new Sequence;
        }
        $this->ambience->deleteFromField($id, "operation_id");
        /**
         * Get the list of sequences
         */
        $sequences = $this->sequence->getListFromParent($id);
        foreach ($sequences as $seq) {
            $this->sequence->delete($seq["sequence_id"]);
        }
        /**
         * Delete the operators attached to the operation
         */
        $sql = "delete from operation_operator
                where operation_id = :operation_id:";
        $this->executeAsPrepared($sql, array("operation_id" => $id), true);
        /**
         * delete the operation
         */
        parent::delete($id);
    }

    /**
     * Duplicate an operation
     * and the children operation_operator, ambience and sequence
     *
     * @param integer $id
     * @return integer
     */
    function duplicate(int $id): int
    {
        $newid = 0;
        $data = $this->lire($id);
        if ($data["operation_id"] > 0) {
            foreach (array("date_end", "debit", "tidal_coef", "water_regime_id", "uuid") as $field) {
                $data[$field] = "";
            }
            $data["operation_id"] = 0;
            $data["operation_name"] .= " - copy";
            $data["date_start"] = $this->getDateHeure();
            if ($data["freshwater"]) {
                $data["freshwater"] = 1;
            } else {
                $data["freshwater"] = 0;
            }
            $newid = $this->write($data);
            if ($newid > 0) {
                /**
                 * Recopy the list of operators
                 */
                $operator = new Operator;
                $operators = array();
                $isResponsible = 0;
                foreach ($operator->getListFromOperation($id, false) as $row) {
                    $operators[] = $row["operator_id"];
                    if ($row["is_responsible"]) {
                        $isResponsible = $row["operator_id"];
                    }
                }
                $operator->setOperatorsToOperation($newid, $operators, $isResponsible);
                /**
                 * Duplicate the ambience (operation)
                 */
                $ambience = new Ambience;
                $dambience = $ambience->getFromOperation($id);
                if ($dambience["ambience_id"] > 0) {
                    $dambience["ambience_id"] = 0;
                    $dambience["operation_id"] = $newid;
                    foreach (array("speed_id", "current_speed", "current_speed_min", "current_speed_max", "water_heigh", "water_height_min", "water_height_max", "flow_trend_id", "turbidity_id", "uuid") as $field) {
                        $dambience[$field] = "";
                    }
                    $ambience->ecrire($dambience);
                }
                /**
                 * Duplicate the sequences
                 */
                $sequence = new Sequence;
                $sequences = $sequence->getListFromParent($id);
                foreach ($sequences as $row) {
                    $sequence->duplicate($row["sequence_id"], $newid);
                }
            }
        } else {
            throw new PpciException(_("L'opération à dupliquer n'existe pas"));
        }
        return $newid;
    }
}
