<?php

namespace App\Libraries;

use App\Models\AmbienceTemplate;
use App\Models\AnalysisTemplate;
use App\Models\Document;
use App\Models\MeasureTemplate;
use App\Models\Protocol as ModelsProtocol;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Protocol extends PpciLibrary
{
    /**
     * @var Models
     */
    protected PpciModel $dataclass;
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsProtocol;
        $this->keyName = "protocol_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }


    function list()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getListProtocol(), "data");
        $this->vue->set("param/protocolList.tpl", "corps");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/protocolChange.tpl");
        $at = new AnalysisTemplate;
        $this->vue->set($at->getListe(1), "dataat");
        $ambienceTemplate = new AmbienceTemplate;
        $this->vue->set($ambienceTemplate->getListe(1), "ambiences");
        return $this->vue->send();
    }
    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set("param/protocolDisplay.tpl", "corps");
        /**
         * Get the associated documents
         */
        $document = new Document;
        $this->vue->set($document->documentgetListFromParent("protocol", $this->id), "dataDoc");
        $this->vue->set("protocol", "moduleParent");
        $this->vue->set($this->id, "parent_id");

        /**
         * List of measures templates
         */
        $mt = new MeasureTemplate;
        $this->vue->set($mt->getListFromProtocol($this->id), "mtdata");
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
        } catch (PpciException $e) {
            return false;
        };
    }
    function getTaxonTemplate()
    {
        $this->vue = service("ViewJson");
        if ($this->id > 0 && $_REQUEST["taxon_id"] > 0) {
            $this->vue->setJson($this->dataclass->getTaxonTemplate($this->id, $_REQUEST["taxon_id"]));
            return $this->vue->send();
        }
    }
}
