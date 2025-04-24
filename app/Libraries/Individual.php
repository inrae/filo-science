<?php

namespace App\Libraries;

use App\Models\Campaign;
use App\Models\Individual as ModelsIndividual;
use App\Models\Operation;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class Individual extends PpciLibrary
{
    /**
     * @var ModelsIndividual
     */
    protected PpciModel $dataclass;
    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsIndividual;
    }
    function listFromCampaign()
    {
        try {
            if ($_REQUEST["campaign_id"] > 0) {
                require_once "modules/classes/campaign.class.php";
                $campaign = new Campaign;
                $campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);
                $dcampaign = $campaign->read($campaign_id);
                if (!verifyProject($dcampaign["project_id"])) {
                    throw new PpciException(_("Vous ne disposez pas des droits suffisants pour réaliser l'opération"));
                }
                $this->vue->set($this->dataclass->getListFromCampaign($campaign_id));
                return $this->vue->send();
            } else {
                throw new PpciException(_("Le numéro de campagne n'a pas été fourni"));
            }
        } catch (PpciException $e) {
            $this->message->set($e->getMessage());
            return defaultPage();
        }
    }
    function listFromOperation()
    {
        try {
            if ($_REQUEST["operation_id"] > 0) {
                $operation = new Operation;
                $operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
                $doperation = $operation->getDetail($operation_id);
                if (!verifyProject($doperation["project_id"])) {
                    throw new PpciException(_("Vous ne disposez pas des droits suffisants pour réaliser l'opération"));
                }
                $this->vue->set($this->dataclass->getListFromOperation($operation_id));
                return $this->vue->send();
            } else {
                throw new PpciException(_("Le numéro d'opération n'a pas été fourni"));
            }
        } catch (PpciException $e) {
            $this->message->set($e->getMessage());
            return defaultPage();
        }
    }
}
