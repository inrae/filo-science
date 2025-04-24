<?php 
namespace App\Libraries;

use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Xx extends PpciLibrary { 
    /**
     * @var xx
     */
    protected PpciModel $this->dataclass;
    private $keyName;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new XXX();
        $keyName = "xxx_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

/**
 * Created : 30 juin 2016
 * Creator : quinton
 * Encoding : UTF-8
 * Copyright 2016 - All rights reserved
 */
require_once 'modules/classes/project.class.php';
$this->dataclass = new Project;
$keyName = "project_id";
$this->id = $_REQUEST[$keyName];


    function list()
{
$this->vue=service('Smarty');
        /*
         * Display the list of all records of the table
         */
        try {
            $this->vue->set($this->dataclass->getListe(2), "data");
            $this->vue->set("param/projectList.tpl", "corps");
        } catch (Exception $e) {
            $this->message->set($e->getMessage(), true);
        }
        }

    function display()
{
$this->vue=service('Smarty');
        $this->vue->set($this->dataclass->getDetail($this->id), "data");
        $this->vue->set("param/projectDisplay.tpl", "corps");
        $this->vue->set($this->dataclass->getAllGroupsFromproject($this->id), "groupes");
        include_once 'modules/classes/document.class.php';
        $document = new Document;
        $this->vue->set($document->documentGetListFromParent("project", $this->id), "dataDoc");
        $this->vue->set("project", "moduleParent");
        $this->vue->set($this->id, "parent_id");
        }
    function change()
{
$this->vue=service('Smarty');
        /*
         * open the form to modify the record
         * If is a new record, generate a new record with default value :
         * $_REQUEST["idParent"] contains the identifiant of the parent record
         */
        $this->dataRead( $this->id, "param/projectChange.tpl");
        $this->vue->set("project", "moduleParent");
        /*
         * Recuperation des groupes
         */
        $this->vue->set($this->dataclass->getAllGroupsFromproject($this->id), "groupes");
        /**
         * Get the list of the protocols
         */
        include_once "modules/classes/protocol.class.php";
        $protocol = new Protocol;
        $this->vue -> set($protocol->getListe("protocol_name"), "protocols");
        }
    function write()
{
try {
            $this->id =         try {
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST["xx_id"] = $this->id;
            return true;
        } catch (PpciException $e) {
            return false;
        }
            if ($this->id > 0) {
                $_REQUEST[$this->keyName] = $this->id;
                return true;
            } else {
                return false;
            }
        } catch (PpciException) {
            return false;
        }
        /*
         * write record in database
         */
        $this->id = dataWrite($this->dataclass, $_REQUEST);
        if ($this->id > 0) {
            $_REQUEST[$keyName] = $this->id;
            /*
             * Rechargement eventuel des projects autorises pour l'utilisateur courant
             */
            try {
                $this->dataclass->initprojects();
            } catch (Exception $e) {
                if ($APPLI_modeDeveloppement) {
                    $this->message->set($e->getMessage(), true);
                }
            }
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
