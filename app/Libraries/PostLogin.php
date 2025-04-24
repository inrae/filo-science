<?php

namespace App\Libraries;

use App\Models\SearchCampaign;
use Ppci\Libraries\PpciLibrary;
use TranslateId;

class PostLogin extends PpciLibrary
{
    static function index() {
        $translators = array(
            array("name" => "ti_campaign", "attr" => "campaign_id"),
            array("name" => "ti_operation", "attr" => "operation_id"),
            array("name" => "ti_sequence", "attr" => "sequence_id"),
            array("name" => "ti_sequenceGear", "attr" => "sequence_gear_id"),
            array("name" => "ti_sample", "attr" => "sample_id"),
            array("name" => "ti_individual", "attr" => "individual_id"),
            array("name" => "ti_ambience", "attr" => "ambience_id"),
            array("name" => "ti_analysis", "attr" => "analysis_id"),
            array("name" => "ti_sequencePoint", "attr" => "sequence_point_id")
        );
        foreach ($translators as $translator) {
            if (!isset($_SESSION[$translator["name"]])) {
                $_SESSION[$translator["name"]] = new TranslateId($translator["attr"]);
            }
        }
        if (!isset($_SESSION["searchCampaign"])) {
            $_SESSION["searchCampaign"] = new SearchCampaign();
        }
        
    }
}
