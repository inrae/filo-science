<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\SequencePoint as LibrariesSequencePoint;

class SequencePoint extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesSequencePoint();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        $this->lib->write();
        return $this->change();
    }

    function delete()
    {
        $this->lib->delete();
        return $this->change();
    }
}
