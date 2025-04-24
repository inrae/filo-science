<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class  extends PpciLibrary { 
    /**
     * @var Models
*/
    protected PpciModel $dataclass;
    

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ;
        $this->keyName = "";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }
include_once 'modules/classes/taxaTemplate.class.php';
$this->dataclass = new TaxaTemplate;
$this->keyName = "taxa_template_id";
$this->id = $_REQUEST[$this->keyName];


    function list()
{
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        $this->vue->set($this->dataclass->getListe(), "data");
        $this->vue->set("param/taxatemplateList.tpl", "corps");
        }
    function change()
{
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $data = $this->dataRead( $this->id, "param/taxatemplateChange.tpl");
        /**
         * Get the list of taxa
         */
        include_once 'modules/classes/taxon.class.php';
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
        }
    function write()
{
try {
            
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST[$this->keyName] = $this->id;
            return true;
        } catch (PpciException $e) {
            return false;
        }
           
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
                if (!empty($_POST[$name]) ) {
                    $grid[] = array(
                        "row"=>$row,
                        "col"=>$col,
                        "val"=>$_POST[$name]
                    );
                }
            }
        }
        $data["taxa_model"] = json_encode($grid);
        $this->id = $this->dataWrite($this->dataclass, $data);
        if ($this->id > 0) {
            $_REQUEST[$this->keyName] = $this->id;
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
