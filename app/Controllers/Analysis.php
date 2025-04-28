<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Analysis as LibrariesAnalysis;
use App\Libraries\Sequence;

class Analysis extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesAnalysis();
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
