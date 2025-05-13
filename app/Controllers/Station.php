<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Station as LibrariesStation;

class Station extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesStation();
    }
    function list()
    {
        return $this->lib->list();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            return $this->list();
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
    function import()
    {
        $this->lib->import();
        return $this->lib->list();
    }
    function getCoordinate()
    {
        return $this->lib->getCoordinate();
    }
}
