<?php

namespace App\Libraries;

use App\Models\AmbienceTemplate as ModelsAmbienceTemplate;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class AmbienceTemplate extends PpciLibrary
{
    /**
     * @var ModelsAmbienceTemplate
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsAmbienceTemplate;
        $this->keyName = "ambience_template_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getListe(1), "data");
        $this->vue->set("param/ambienceTemplateList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        /*
		 * open the form to modify the record
		 * If is a new record, generate a new record with default value :
		 * $_REQUEST["idParent"] contains the identifiant of the parent record
		 */
        $this->dataRead($this->id, "param/ambienceTemplateChange.tpl");
        return $this->vue->send();
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
    }
    function delete()
    {
        /*
		 * delete record
		 */
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException) {
            return false;
        };
    }
}
