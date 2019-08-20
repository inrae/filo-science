<?php
include_once 'modules/classes/taxaTemplate.class.php';
$dataClass = new TaxaTemplate($bdd, $ObjetBDDParam);
$keyName = "taxa_template_id";
$id = $_REQUEST[$keyName];

switch ($t_module["param"]) {
    case "list":
        /*
         * Display the list of all records of the table
         */
        $vue->set($dataClass->getListe(), "data");
        $vue->set("param/taxatemplateList.tpl", "corps");
        break;
    case "change":
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = dataRead($dataClass, $id, "param/taxatemplateChange.tpl");
        /**
         * Get the list of taxa
         */
        include_once 'modules/classes/taxon.class.php';
        $taxon = new Taxon($bdd, $ObjetBDDParam);
        $vue->set($taxon->getListCode($data["freshwater"]), "taxa");
        /**
         * set the actual grid content
         */
        $grid = json_decode($data["taxa_model"], true);
        $newgrid = array();
        foreach ($grid as $element) {
            $name = "grid" . $element["row"] . "-" . $element["col"];
            $newgrid[$element["row"]][$element["col"]] = $element["val"];
        }
        $vue->set($newgrid, "grid");
        break;
    case "write":
        /*
         * write record in database
         */
        $data = array(
            "taxa_template_id" => $_POST["taxa_template_id"],
            "taxa_template_name" => $_POST["taxa_template_name"],
            "freshwater" => $_POST["freshwater"]
        );
        /**
         * Preparation of the storage of the grid
         */
        $grid = array();
        for ($row = 1; $row < 5; $row++) {
            for ($col = 1; $col < 7; $col++) {
                $name = "grid" . $row . "-" . $col;
                if (strlen($_POST[$name]) > 0) { 
                    $grid[] = array(
                        "row"=>$row,
                        "col"=>$col,
                        "val"=>$_POST[$name]
                    );
                }
            }
        }
        $data["taxa_model"] = json_encode($grid);
        $id = dataWrite($dataClass, $data);
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
}
