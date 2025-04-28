<?php

namespace App\Models;

class SearchCampaign extends SearchParam
{
    function __construct()
    {
        $this->param = array(
            "project_id" => "",
            "is_active" => 1
        );
        $this->paramNum = array("project_id", "is_active");
    }
}
