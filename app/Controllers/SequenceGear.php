<?php

namespace App\Controllers;

use App\Libraries\Sequence;
use \Ppci\Controllers\PpciController;
use App\Libraries\SequenceGear as LibrariesSequenceGear;

class SequenceGear extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesSequenceGear();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            $sequence = new Sequence;
            return $sequence->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            $sequence = new Sequence;
            return $sequence->display();
        } else {
            return $this->change();
        }
    }
}
