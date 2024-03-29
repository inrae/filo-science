<?php
class IndividualException extends Exception
{
}

/**
 * ORM for the table individual
 */
class Individual extends ObjetBDD
{
  private $sql = "select individual_id, individual_id as individual_uid, sample_id, sexe_id, pathology_id
                  , sl, fl, tl, wd, ot, weight
                  ,individual_code
                  ,other_measure, individual_comment, age
                  ,measure_estimated, pathology_codes, tag, tag_posed, transmitter, spaghetti_brand
                  ,pathology_name, pathology_code
                  ,sexe_name, sexe_code
                  ,other_measures, i.uuid
                  ,catching_time, release_time, anesthesia_duration, marking_duration, anesthesia_product, product_concentration
                  ,release_station_id, transmitter_type_id, it.project_id
                  ,array_to_string(year, ',') as year
                  ,case when s.taxon_id is not null then
                  s.taxon_id else it.taxon_id end,
                  case when s.taxon_id is not null then
                  ts.scientific_name else ti.scientific_name end
                  from individual i
                  left outer join individual_tracking it using (individual_id)
                  left outer join pathology using (pathology_id)
                  left outer join sexe using (sexe_id)
                  left outer join v_individual_other_measures using (individual_id)
                  left outer join sample s using (sample_id)
                  left outer join taxon ts on (s.taxon_id = ts.taxon_id)
                  left outer join taxon ti on (it.taxon_id = ti.taxon_id)
    ";
  public $individualTracking;
  /**
   * Constructor
   *
   * @param pdo $bdd
   * @param array $param
   */
  function __construct($bdd, $param = array())
  {
    $this->table = "individual";
    $this->colonnes = array(
      "individual_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
      "sample_id" => array("type" => 1, "parentAttrib" => 1),
      "sexe_id" => array("type" => 1),
      "pathology_id" => array("type" => 1),
      "sl" => array("type" => 1),
      "fl" => array("type" => 1),
      "tl" => array("type" => 1),
      "wd" => array("type" => 1),
      "ot" => array("type" => 1),
      "weight" => array("type" => 1),
      "age" => array("type" => 1),
      "measure_estimated" => array("type" => 1,  "requis" => 1, "defaultValue" => 0),
      "other_measure" => array("type" => 0),
      "individual_comment" => array("type" => 0),
      "pathology_codes" => array("type" => 0),
      "tag" => array("type" => 0),
      "tag_posed" => array("type" => 0),
      "transmitter" => array("type" => 0),
      "uuid" => array("type" => 0, "defaultValue" => "getUUID"),
      "individual_code" => array("type" => 0),
      "spaghetti_brand" => array("type" => 0),
      "catching_time" => array("type" => 0),
      "release_time" => array("type" => 0),
      "anesthesia_duration" => array("type" => 0),
      "marking_duration" => array("type" => 1),
      "anesthesia_product" => array("type" => 0),
      "product_concentration" => array("type" => 0)
    );
    parent::__construct($bdd, $param);
  }
  /**
   * Get the list of individuals attached to a sample
   *
   * @param int $sample_id
   * @return array
   */
  function getListFromSample($sample_id)
  {
    $where = " where sample_id = :sample_id";
    return $this->getListeParamAsPrepared($this->sql . $where, array("sample_id" => $sample_id));
  }
  /**
   * Add the value individual_uid for display individual_id in forms
   *
   * @param int $id
   * @param boolean $getDefault
   * @param string $parentValue
   * @return array
   */
  function lire($id, $getDefault = true, $parentValue = "")
  {
    if ($id > 0) {
      $where = " where individual_id = :id";
      $data = $this->lireParamAsPrepared($this->sql . $where, array("id" => $id));
    } else {
      $data = $this->getDefaultValue($parentValue);
    }
    if ($data["individual_id"] > 0) {
      $data["individual_uid"] = $data["individual_id"];
    }
    return $data;
  }

  /**
   * override of write function to record data attached to the tracking
   *
   * @param array $data
   * @return integer
   */
  function ecrire( $data)
  {
    if (empty($data["measure_estimated"]) ) {
      $data["measure_estimated"] = 0;
    }
    if (strlen($data["uuid"]) != 36) {
      unset($data["uuid"]);
    }
    $id = parent::ecrire($data);
    if ($id > 0 && $data["isTracking"]) {
      $data["individual_id"] = $id;
      if (!$this->individualTracking) {
        include_once 'modules/classes/tracking/individual_tracking.class.php';
        $this->individualTracking = new IndividualTracking($this->connection, $this->paramori);
      }
      $this->individualTracking->ecrire($data);
    }
    return $id;
  }

  /**
   * Delete a fish, with children tables
   *
   * @param integer $id
   * @return void
   */
  function supprimer( $id)
  {
    include_once 'modules/classes/tracking/individual_tracking.class.php';
    $it = new IndividualTracking($this->connection, $this->paramori);
    $it->supprimer($id);
    parent::supprimer($id);
  }

  /**
   * Delete from sample if it's not a tracked fish,
   * else delete only the reference to the sample
   *
   * @param integer $id
   * @return void
   */
  function deleteFromSample(int $id)
  {
    $data = $this->lire($id);
    if ($data["taxon_id"] > 0) {
      /**
       * It's a fish tracked!
       */
      $data["sample_id"] = "";
      $this->ecrire($data);
    } else {
      parent::supprimer($id);
    }
  }
  function getListFromOperation(int $operation_id)
  {
    $where = " where operation_id = :operation_id";
    $sql = $this->sql . "
                left outer join sequence using (sequence_id)
        ";
    return $this->getListeParamAsPrepared($sql . $where, array("operation_id" => $operation_id));
  }

  function getListFromCampaign(int $campaign_id)
  {
    $where = " where campaign_id = :campaign_id";
    $sql = $this->sql . "
                left outer join sequence using (sequence_id)
                left outer join operation using (operation_id)
        ";
    return $this->getListeParamAsPrepared($sql . $where, array("campaign_id" => $campaign_id));
  }
}
