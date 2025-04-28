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
        return $this->lib->exec();
    }
    function importExec()
    {
        return $this->lib->importExec();
    }
}
