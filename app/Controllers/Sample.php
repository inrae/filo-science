<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Sample as LibrariesSample;
use App\Libraries\Sequence;

class Sample extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesSample();
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
        if ($this->lib->delete()) {
            $sequence = new Sequence;
            return $sequence->display();
        } else {
            return $this->change();
        }
    }
    function deleteIndividual()
    {
        $this->lib->deleteIndividual();
        return $this->change();
    }
}
