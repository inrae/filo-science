<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ImportExec as LibrariesImportExec;

class ImportExec extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesImportExec();
    }
    function exec()
    {
        return $this->lib->exec();
    }
}
