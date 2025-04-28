<?php

namespace App\Controllers;

use App\Libraries\IndividualTracking;
use \Ppci\Controllers\PpciController;
use App\Libraries\Location as LibrariesLocation;

class Location extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesLocation();
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
}
