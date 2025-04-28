<?php

namespace App\Controllers;

use App\Libraries\Campaign;
use \Ppci\Controllers\PpciController;
use App\Libraries\Operation as LibrariesOperation;

class Operation extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesOperation();
    }
    function display()
    {
        return $this->lib->display();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            return $this->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            $campaign = new Campaign;
            return $campaign->display();
        } else {
            return $this->change();
        }
    }
    function operatorsChange()
    {
        return $this->lib->operatorsChange();
    }
    function duplicate()
    {
        return $this->lib->duplicate();
    }
}
