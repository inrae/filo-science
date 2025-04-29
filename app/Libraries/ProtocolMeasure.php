<?php

namespace App\Libraries;

use App\Models\MeasureTemplate;
use App\Models\Protocol as ModelsProtocol;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ProtocolMeasure extends PpciLibrary
{
    /**
     * @var ModelsProtocol
     */
    protected PpciModel $dataclass;
    protected MeasureTemplate $measureTemplate;

    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsProtocol;
        $this->keyName = "protocol_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
        $this->measureTemplate = new MeasureTemplate;
    }

    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "param/protocolMeasureChange.tpl");
        $this->vue->set($this->measureTemplate->getTotalListForProtocol($this->id), "measures");
        return $this->vue->send();
    }
    function write()
    {
        $db = $this->dataclass->db;
        try {
            $db->transBegin();
            $this->dataclass->ecrireTableNN("protocol_measure", "protocol_id", "measure_template_id", $this->id, $_POST["measure_template_id"]);
            $db->transCommit();
            return true;
        } catch (PpciException $e) {
            $this->message->set(_("Echec d'écriture de la liste des modèles de mesures rattachées au protocole"), true);
            $this->message->setSyslog($e->getMessage());
            if ($db->transEnabled) {
                $db->transRollback();
            }
            return false;
        }
    }
}
