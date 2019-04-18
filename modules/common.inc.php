<?php
/**
 * Code execute systematiquement a chaque appel, apres demarrage de la session
 * Utilise notamment pour recuperer les instances de classes stockees en 
 * variables de session
 */

if (!isset($_SESSION["ti_campaign"])) {
          $_SESSION["ti_campaign"] = new TranslateId("campaign_id");
}
if (!isset($_SESSION["searchCampaign"])) {
    $_SESSION["searchCampaign"] = new SearchCampaign();
}
