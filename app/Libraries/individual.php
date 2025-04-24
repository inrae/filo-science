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
require_once 'modules/classes/individual.class.php';
$this->dataclass = new Individual;

  function listFromCampaign() {
    try {
      if ($_REQUEST["campaign_id"] > 0) {
        require_once "modules/classes/campaign.class.php";
        $campaign = new Campaign;
        $campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);
        $dcampaign = $campaign->lire($campaign_id);
        if (!verifyProject($dcampaign["project_id"])) {
          throw new IndividualException(_("Vous ne disposez pas des droits suffisants pour réaliser l'opération"));
        }
        $this->vue->set($this->dataclass->getListFromCampaign($campaign_id));
      } else {
        throw new IndividualException(_("Le numéro de campagne n'a pas été fourni"));
      }
    } catch (IndividualException $e) {
      $module_codretour = -1;
      $this->message->set($e->getMessage());
    }
    }
  function listFromOperation() {
    try {
      if ($_REQUEST["operation_id"] > 0) {
        require_once "modules/classes/operation.class.php";
        $operation = new Operation;
        $operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
        $doperation = $operation->getDetail($operation_id);
        if (!verifyProject($doperation["project_id"])) {
          throw new IndividualException(_("Vous ne disposez pas des droits suffisants pour réaliser l'opération"));
        }
        $this->vue->set($this->dataclass->getListFromOperation($operation_id));
      } else {
        throw new IndividualException(_("Le numéro d'opération n'a pas été fourni"));
      }
    } catch (IndividualException $e) {
      $module_codretour = -1;
      $this->message->set($e->getMessage());
    }
    }
}
