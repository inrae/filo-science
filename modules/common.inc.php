<?php
/**
 * Code execute systematiquement a chaque appel, apres demarrage de la session
 * Utilise notamment pour recuperer les instances de classes stockees en 
 * variables de session
 */

if (!isset($_SESSION["ti_campaign"])) {
          $_SESSION["ti_campaign"] = new TranslateId("campaign_id");
}
if (!isset($_SESSION["ti_operation"])) {
    $_SESSION["ti_operation"] = new TranslateId("operation_id");
}
if (!isset($_SESSION["ti_sequence"])) {
    $_SESSION["ti_sequence"] = new TranslateId("sequence_id");
}
if (!isset($_SESSION["ti_sequenceGear"])) {
    $_SESSION["ti_sequenceGear"] = new TranslateId("sequence_gear_id");
}
if (!isset($_SESSION["ti_sample"])) {
    $_SESSION["ti_sample"] = new TranslateId("sample_id");
}
if (!isset($_SESSION["ti_individual"])) {
    $_SESSION["ti_individual"] = new TranslateId("individual_id");
}
if (!isset($_SESSION["ti_ambience"])) {
    $_SESSION["ti_ambience"] = new TranslateId("ambience_id");
}
if (!isset($_SESSION["ti_analysis"])) {
    $_SESSION["ti_analysis"] = new Translateid("analysis_id");
}
if (!isset($_SESSION["searchCampaign"])) {
    $_SESSION["searchCampaign"] = new SearchCampaign();
}