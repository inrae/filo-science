<?php

namespace App\Controllers;

use App\Libraries\Protocol;
use \Ppci\Controllers\PpciController;
use App\Libraries\ProtocolMeasure as LibrariesProtocolMeasure;

class ProtocolMeasure extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesProtocolMeasure();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            $protocol = new Protocol;
            return $protocol->display();
        } else {
            return $this->change();
        }
    }
}
