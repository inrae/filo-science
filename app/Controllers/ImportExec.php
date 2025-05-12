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
    function index() {
        return $this->lib->display();
    }
    function exec()
    {
        $this->lib->exec();
        return $this->lib->display();
    }
}
