<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Document as LibrariesDocument;
use App\Libraries\Operation;
use App\Libraries\Project;
use App\Libraries\Protocol;
use Ppci\Libraries\PpciLibrary;

class Document extends PpciController
{
    protected $lib;
    private PpciLibrary $back;
    function __construct()
    {
        $this->lib = new LibrariesDocument();
    }
    function write($source)
    {
        $this->lib->write();
        return $this->back($source);
    }
    function delete($source)
    {
        $this->lib->delete();
        return $this->back($source);
           
    }
    function get()
    {
        return $this->lib->get();
    }
    function back($source)
    {
        if ($source == "project") {
            $this->back = new Project;
        } elseif($source == "protocol") {
            $this->back = new Protocol;
        } else {
            $this->back = new Operation;
        }
        return $this->back->display();
    }
}
