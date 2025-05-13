<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Export as LibrariesExport;

class Export extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesExport();
    }
    function exec()
    {
        if( ! $this->lib->exec()) {
            return defaultPage();
        }
    }
    function importExec()
    {
        $this->lib->importExec();
        return defaultPage();
    }
}
