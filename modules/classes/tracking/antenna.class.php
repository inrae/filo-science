<?php
class Antenna extends ObjetBDD
{
  private $sridAntenna = 4326;
  private $sql = "select antenna_id, a.station_id, technology_type_id, antenna_code, radius
                    ,station_name, station_type_name
                    ,station_long, station_lat
                    ,technology_type_name
                    ,date_from, date_to
                    from antenna a
                    join station_tracking st on (a.station_id = st.station_id)
                    join station s on (st.station_id = s.station_id)
                    join station_type using (station_type_id)
                    left outer join technology_type using (technology_type_id)";

  /**
   * Constructor
   *
   * @param PDO $bdd
   * @param array $param
   */
  function __construct(PDO $bdd, array $param = array())
  {
    $this->table = "antenna";
    $date = new DateTime();
    $date->add(new DateInterval('P1Y'));
    $this->colonnes = array(
      "antenna_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
      "station_id" => array("type" => 1, "requis" => 1, "parentAttrib" => 1),
      "technology_type_id" => array("type" => 1),
      "antenna_code" => array("type" => 0, "requis" => 1),
      "radius" => array("type" => 1),
      "geom_polygon" => array("type" => 4),
       "date_from" => array("type" => 2, "defaultValue" => $this->formatDateDBversLocal(date('Y-m-d'))),
      "date_to" => array("type" => 2, "defaultValue"=> $this->formatDateDBversLocal($date->format("Y-m-d")))
    );
    parent::__construct($bdd, $param);
  }
  /**
   * overwrite of ecrire to generate the polygon of type circle
   *
   * @param array $data
   * @return int
   */
  function ecrire($data)
  {
    if ($data["radius"] == 0) {
      $data["geom_polygon"] = "";
    }
    $id = parent::ecrire($data);
    if ($data["radius"] > 0 && is_numeric($data["radius"])) {
      /**
       * Generate a polygon from the center of the station and the radius
       *
       * Get the coordinates of the station
       */
      require_once "modules/classes/station.class.php";
      $station = new Station($this->connection, $this->paramori);
      $dstation = $station->getDetail($data["station_id"]);
      if (!empty($dstation["station_long"])  && !empty($dstation["station_lat"])) {
        $sql = "update antenna set geom_polygon =
                        st_transform(
                            st_buffer (
                                st_transform (
                                    st_geomfromtext('POINT(" . $dstation["station_long"] . " " . $dstation["station_lat"] . ")', " . $this->sridAntenna . ")
                                , " . $dstation["metric_srid"] . ")
                            , " . $data["radius"] . ")
                        ," . $this->sridAntenna . ")
                        where antenna_id = $id";
        $this->execute($sql);
      }
    }
    return $id;
  }
  /**
   * Get the list of the antennas with associated tables
   *
   * @param string $order
   * @return array
   */
  function getListFromParent($parentId, $order = "")
  {
    $where = " where a.station_id = :parentId";
    !empty($order) ? $orderby = " order by $order" : $orderby = "";
    return $this->getListeParamAsPrepared($this->sql . $where . $orderby, array("parentId" => $parentId));
  }

  /**
   * Get the list of antennas attached to a project
   *
   * @param integer $projectId
   * @return array
   */
  function getListFromProject(int $projectId)
  {
    $where = " where project_id = :project_id";
    $order = " order by station_name, antenna_code";
    return $this->getListeParamAsPrepared($this->sql . $where . $order, array("project_id" => $projectId));
  }

  /**
   * Get the id of an antenna from its code
   *
   * @param string $code
   * @return integer
   */
  function getIdFromCode(string $code, string $date): int
  {
    $sql = "select antenna_id from antenna where antenna_code = :code and :date::date between date_from and date_to";
    $data = $this->lireParamAsPrepared($sql, array("code" => $code, "date"=>$date));
    $data["antenna_id"] > 0 ? $id = $data["antenna_id"] : $id = 0;
    return $id;
  }
}
