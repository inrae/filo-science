<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\StationTracking as LibrariesStationTracking;

class StationTracking extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesStationTracking();
    }
    function list()
    {
        return $this->lib->list();
    }
    function change()
    {
        return $this->lib->change();
    }
    function display()
    {
        return $this->lib->display();
    }
    function write()
    {
        if ($this->lib->write()) {
            return $this->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            return $this->list();
        } else {
            return $this->change();
        }
    }
    function getSensors()
    {
        return $this->lib->getSensors();
    }
}
