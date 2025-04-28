<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\IndividualTracking as LibrariesIndividualTracking;

class IndividualTracking extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesIndividualTracking();
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
    function export()
    {
        return $this->lib->export();
    }
    function import()
    {
        return $this->lib->import();
    }
    function importExec()
    {
        return $this->lib->importExec();
    }
}
