<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Detection as LibrariesDetection;
use App\Libraries\IndividualTracking;

class Detection extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesDetection();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            $individualTracking = new IndividualTracking;
            return $individualTracking->list();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            $individualTracking = new IndividualTracking;
            return $individualTracking->list();
        } else {
            return $this->change();
        }
    }
    function calculateSunPeriod()
    {
        return $this->lib->calculateSunPeriod();
    }
    function calculateSunPeriodExec()
    {
        return $this->lib->calculateSunPeriodExec();
    }
}
