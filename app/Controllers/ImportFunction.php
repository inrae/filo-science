<?php

namespace App\Controllers;

use App\Libraries\ImportDescription;
use \Ppci\Controllers\PpciController;
use App\Libraries\ImportFunction as LibrariesImportFunction;

class ImportFunction extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesImportFunction();
    }
    function change()
    {
        return $this->lib->change();
    }
    function write()
    {
        if ($this->lib->write()) {
            $importDescription = new ImportDescription;
            return $importDescription->display();
        } else {
            return $this->change();
        }
    }
    function delete()
    {
        if ($this->lib->delete()) {
            $importDescription = new ImportDescription;
            return $importDescription->display();
        } else {
            return $this->change();
        }
    }
    function getFunctionDescription()
    {
        return $this->lib->getFunctionDescription();
    }
}
