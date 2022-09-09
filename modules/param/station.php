<?php
require_once 'modules/classes/station.class.php';
$dataClass = new station($bdd, $ObjetBDDParam);
$keyName = "station_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListFromproject(0, false), "data");
        $vue->set("param/stationList.tpl", "corps");
        $vue->set($_SESSION["projects"], "projects");
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        dataRead($dataClass, $id, "param/stationChange.tpl");
        setParamMap($vue);
        $vue->set($_SESSION["projects"], "projects");
        require_once 'modules/classes/param.class.php';
        $river = new Param($bdd, "river");
        $vue->set($river->getListe("river_name"), "rivers");
        break;
    case "write":
        /*
         * write record in database
         */
        $id = dataWrite($dataClass, $_REQUEST);
        if ($id > 0) {
            $_REQUEST[$keyName] = $id;
        }
        break;
    case "delete":
        /*
         * delete record
         */
        dataDelete($dataClass, $id);
        break;
    case "import":
        if (file_exists($_FILES['upfile']['tmp_name'])) {
            require_once 'modules/classes/import.class.php';
            $i = 0;
            try {
                $bdd->beginTransaction();
                $import = new Import($_FILES['upfile']['tmp_name'], $_POST["separator"], false, array(
                    "name",
                    "code",
                    "long",
                    "lat",
                    "pk",
                    "river",
                    "number",
                    "station_type_id"
                ));
                require_once 'modules/classes/param.class.php';
                $river = new Param($bdd, "river");
                require_once "modules/classes/tracking/station_tracking.class.php";
                $stationTracking = new StationTracking($bdd, $ObjetBDDParam);
                $rows = $import->getContentAsArray();
                foreach ($rows as $row) {
                    if (!empty($row["name"])) {
                        /*
                         * Ecriture en base, en mode ajout ou modification
                         */
                        $data = array(
                            "station_name" => $row["name"],
                            "project_id" => $_POST["project_id"],
                            "station_code" => $row["code"],
                            "station_long" => $row["long"],
                            "station_lat" => $row["lat"],
                            "station_pk" => $row["pk"],
                            "station_number" => $row["number"],
                            "station_id" => $dataClass->getIdFromName($row["name"]),
                            "station_type_id" => $row["station_type_id"]
                        );
                        if (!empty($row["river"])) {
                            $data["river_id"] = $river->getIdFromName($row["river"], true);
                        }
                        $station_id = $dataClass->ecrire($data);
                        if (!empty($data["station_type_id"]) && $station_id > 0) {
                            /**
                             * Write the type of tracking station
                             */
                            $dataTracking = array(
                                "station_id" => $station_id,
                                "station_type_id" => $data["station_type_id"],
                                "station_active" => 1
                            );
                            $stationTracking->ecrire($dataTracking);
                        }
                        $i++;
                    }
                }
                $bdd->commit();
                $message->set(sprintf(_("%d stations(s) importée(s)"), $i));
                $module_coderetour = 1;
            } catch (Exception $e) {
                $bdd->rollback();
                $message->set(_("Impossible d'importer les stations"));
                $message->set($e->getMessage());
                $module_coderetour = -1;
            }
        } else {
            $message->set(_("Impossible de charger le fichier à importer"));
            $module_coderetour = -1;
        }
        break;
    case "getFromProject":
        $vue->set($dataClass->getListFromproject($_REQUEST["project_id"]));
        break;
    case "getCoordinate":
        $vue->set($dataClass->getCoordinates($_REQUEST["station_id"]));
        break;
}
