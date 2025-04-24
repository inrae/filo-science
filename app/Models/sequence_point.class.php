<?php 
namespace App\Models;
use Ppci\Models\PpciModel;

class SequencePoint extends PpciModel
{

    private $sql = "select sequence_point_id, sequence_id, localisation_id, facies_id
                    , fish_number, sequence_point_number
                    ,localisation_name, facies_name
                    from sequence_point
                    left outer join localisation using (localisation_id)
                    left outer join facies using (facies_id)";

    function __construct(, ?array $param = array())
    {
        $this->table = "sequence_point";
        $this->fields = array(
            "sequence_point_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            "sequence_id" => array("requis" => 1, "type" => 1, "parentAttrib" => 1),
            "localisation_id" => array("type" => 1),
            "facies_id" => array("type" => 1),
            "fish_number" => array("type" => 1),
            "sequence_point_number" => array("type" => 1, "requis" => 1)
        );
        parent::__construct();
    }

    /**
     * Get the list from a sequence
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
     * Get the last number used into a sequence
     *
     * @param integer $sequence_id
     * @return int
     */
    function getLastNumberForSequence(int $sequence_id): int
    {
        $sql = "select max(sequence_point_number) as sequence_point_number from sequence_point
                where sequence_id = :id";
        $data = $this->lireParamAsPrepared($sql, array("id" => $sequence_id));
        $data["sequence_point_number"] > 0 ? $spn = $data["sequence_point_number"] : $spn = 0;
        return $spn;
    }
    /**
     * override the lire function to add the generation of sequence_point_number
     *
     * @param integer $id
     * @param boolean|null $getDefault
     * @param integer|null $sequence_id
     * @return array
     */
    function read( $id, $getDefault = false,  $sequence_id = ""): array
    {
        $data = array();
        if ($id > 0) {
            $data = parent::lire($id, $getDefault, $sequence_id);
        } else {
            $data = $this->getDefaultValue($sequence_id);
            $data["sequence_point_number"] = $this->getLastNumberForSequence($sequence_id) + 1;
        }
        return $data;
    }
}
