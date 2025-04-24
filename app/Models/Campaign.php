<?php 
namespace App\Models;
use Ppci\Models\PpciModel;

/**
 * ORM of table campaign
 */
class Campaign extends PpciModel
{
    private $sql = "SELECT campaign_id, campaign_id as campaign_uid, campaign_name
    , project_id, project_name, metric_srid, protocol_default_id
    from campaign
    join project using (project_id)";
    /**
     * Constructor
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "campaign";
        $this->fields = array(
            "campaign_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "campaign_name" => array("requis" => 1, "type" => 0),
            "project_id" => array("requis" => 1, "parentAttrib" => 1)
        );
        parent::__construct();
    }
    /**
     * Get the detail of a campaign
     *
     * @param integer $id
     * @return array
     */
    function getDetail(int $id): array
    {
        $where = " where campaign_id = :id:";
        return $this->lireParamAsPrepared($this->sql . $where, array("id" => $id));
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
            $where .= $and . " project_id = :project_id:";
            $values["project_id"] = $param["project_id"];
            $and = " and ";
        }
        if (!empty($param["is_active"]) ) {
            $where .= $and . " is_active = :is_active:";
            $and = " and ";
            $values["is_active"] = $param["is_active"];
        }
        if (!empty($and) ) {
            return $this->getListeParamAsPrepared($this->sql . $where, $values);
        } else {
            return array();
        }
    }

    /**
     * Delete a campaign with all attached operations
     *
     * @param integer $id
     * @return void
     */
    function delete($id = null, bool $purge = false)
    {
        $operation = new Operation;
        $operations = $operation->getListFromParent($id);
        foreach ($operations as $op) {
            $op->delete($op["operation_id"]);
        }
        parent::delete($id);
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
        $data = $this->lire($uid);
        $retour = false;
        foreach ($projects as $project) {
            if ($project["project_id"] == $data["project_id"]) {
                $retour = true;
                break;
            }
        }
        return $retour;
    }
}
