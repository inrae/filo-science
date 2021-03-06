<?php
require_once 'modules/classes/individual.class.php';
$dataClass = new Individual($bdd, $ObjetBDDParam);
switch ($t_module["param"]) {
  case "listFromCampaign":
    try {
      if ($_REQUEST["campaign_id"] > 0) {
        require_once "modules/classes/campaign.class.php";
        $campaign = new Campaign($bdd, $ObjetBDDParam);
        $campaign_id = $_SESSION["ti_campaign"]->getValue($_REQUEST["campaign_id"]);
        $dcampaign = $campaign->lire($campaign_id);
        if (!verifyProject($dcampaign["project_id"])) {
          throw new IndividualException(_("Vous ne disposez pas des droits suffisants pour réaliser l'opération"));
        }
        $vue->set($dataClass->getListFromCampaign($campaign_id));
      } else {
        throw new IndividualException(_("Le numéro de campagne n'a pas été fourni"));
      }
    } catch (IndividualException $e) {
      $module_codretour = -1;
      $message->set($e->getMessage());
    }
    break;
  case "listFromOperation":
    try {
      if ($_REQUEST["operation_id"] > 0) {
        require_once "modules/classes/operation.class.php";
        $operation = new Operation($bdd, $ObjetBDDParam);
        $operation_id = $_SESSION["ti_operation"]->getValue($_REQUEST["operation_id"]);
        $doperation = $operation->getDetail($operation_id);
        if (!verifyProject($doperation["project_id"])) {
          throw new IndividualException(_("Vous ne disposez pas des droits suffisants pour réaliser l'opération"));
        }
        $vue->set($dataClass->getListFromOperation($operation_id));
      } else {
        throw new IndividualException(_("Le numéro d'opération n'a pas été fourni"));
      }
    } catch (IndividualException $e) {
      $module_codretour = -1;
      $message->set($e->getMessage());
    }
    break;
}
