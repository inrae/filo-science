<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Probe as LibrariesProbe;
use App\Libraries\StationTracking;

class Probe extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesProbe();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            $stationTracking = new StationTracking;
            return $stationTracking->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            $stationTracking = new StationTracking;
            return $stationTracking->display();
        } else {
            return $this->change();
        }
    }
}
