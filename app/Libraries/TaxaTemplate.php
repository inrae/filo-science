<?php

namespace App\Libraries;

use App\Models\TaxaTemplate as ModelsTaxaTemplate;
use App\Models\Taxon;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class TaxaTemplate extends PpciLibrary
{
    /**
     * @var ModelsTaxaTemplate
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsTaxaTemplate;
        $this->keyName = "taxa_template_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
    function list()
    {
        $this->vue = service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(), "data");
        $this->vue->set("param/taxatemplateList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');

        $data = $this->dataRead($this->id, "param/taxatemplateChange.tpl");
        /**
         * Get the list of taxa
         */
        $taxon = new Taxon;
        $this->vue->set($taxon->getListCode($data["freshwater"]), "taxa");
        /**
         * set the actual grid content
         */
        $grid = json_decode($data["taxa_model"], true);
        $newgrid = array();
        foreach ($grid as $element) {
            $name = "grid" . $element["row"] . "-" . $element["col"];
            $newgrid[$element["row"]][$element["col"]] = $element["val"];
        }
        $this->vue->set($newgrid, "grid");
        return $this->vue->send();
    }
    function write()
    {
        try {
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
                    if (!empty($_POST[$name])) {
                        $grid[] = array(
                            "row" => $row,
                            "col" => $col,
                            "val" => $_POST[$name]
                        );
                    }
                }
            }
            $data["taxa_model"] = json_encode($grid);
            $this->id = $this->dataWrite($data);
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
            }
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }
    function delete()
    {
        /*
         * delete record
         */
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        };
    }
}
