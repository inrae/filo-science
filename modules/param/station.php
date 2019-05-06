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
        include 'modules/gestion/mapInit.php';
        $vue->set($_SESSION["projects"], "projects");
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
                $import = new Import($_FILES['upfile']['tmp_name'], $_POST["separator"], false, array(
                    "name",
                    "code",
                    "x",
                    "y"
                ));
                $rows = $import->getContentAsArray();
                foreach ($rows as $row) {
                    if (strlen($row["name"]) > 0) {
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
                            "station_id" => $dataClass->getIdFromName($row["name"])
                        );
                        $dataClass->ecrire($data);
                        $i++;
                    }
                }
                $message->set(sprintf(_("%d stations(s) importée(s)"), $i));
                $module_coderetour = 1;
            } catch (Exception $e) {
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
?>