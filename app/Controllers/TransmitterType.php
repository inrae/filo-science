<?php

namespace App\Controllers;

use App\Libraries\TransmitterType as LibrariesTransmitterType;
use \Ppci\Controllers\PpciController;


class TransmitterType extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesTransmitterType;
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
}