<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Antenna as LibrariesAntenna;
use App\Libraries\StationTracking;

class Antenna extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesAntenna();
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
