<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Ambience as LibrariesAmbience;
use App\Libraries\Operation;
use App\Libraries\Sequence;
use Ppci\Libraries\PpciLibrary;

class Ambience extends PpciController
{
    protected $lib;
    private PpciLibrary $back;
    function __construct()
    {
        $this->lib = new LibrariesAmbience();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write($source)
    {
        if ($this->lib->write()) {
            return $this->backToList($source);
        } else {
            return $this->change();
        }
    }
    function delete($source)
    {
        if ($this->lib->delete()) {
            return $this->backToList($source);
        } else {
            return $this->change();
        }
    }
    function backToList($source)
    {
        if ($source == "sequence") {
            $this->back = new Sequence;
        } else {
            $this->back = new Operation;
        }
        return $this->back->list();
    }
}
