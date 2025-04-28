<?php

namespace App\Libraries;

use App\Models\Document;
use App\Models\Project as ModelsProject;
use App\Models\Protocol;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Project extends PpciLibrary
{
    /**
     * @var ModelsProject
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsProject;
        $this->keyName = "project_id";
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
        try {
            $this->vue->set($this->dataclass->getListe(2), "data");
            $this->vue->set("param/projectList.tpl", "corps");
        } catch (PpciException $e) {
            $this->message->set($e->getMessage(), true);
        }
        return $this->vue->send();
    }

    function display()
    {
        $this->vue = service('Smarty');
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set("param/projectDisplay.tpl", "corps");
        $this->vue->set($this->dataclass->getAllGroupsFromproject($this->id), "groupes");
        $document = new Document;
        $this->vue->set($document->documentGetListFromParent("project", $this->id), "dataDoc");
        $this->vue->set("project", "moduleParent");
        $this->vue->set($this->id, "parent_id");
        return $this->vue->send();
    }
    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/projectChange.tpl");
        $this->vue->set("project", "moduleParent");
        /*
         * Recuperation des groupes
         */
        $this->vue->set($this->dataclass->getAllGroupsFromproject($this->id), "groupes");
        /**
         * Get the list of the protocols
         */
        $protocol = new Protocol;
        $this->vue->set($protocol->getListe("protocol_name"), "protocols");
        return $this->vue->send();
    }
    function write()
    {
        try {

            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST[$this->keyName] = $this->id;
            /*
             * Rechargement eventuel des projects autorises pour l'utilisateur courant
             */
            $this->dataclass->initprojects();
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
