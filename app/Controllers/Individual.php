<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Individual as LibrariesIndividual;

class Individual extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesIndividual();
    }
    function listFromOperation()
    {
        return $this->lib->listFromOperation();
    }
    function listFromCampaign()
    {
        return $this->lib->listFromCampaign();
    }
}
