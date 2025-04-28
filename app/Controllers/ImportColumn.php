<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ImportColumn as LibrariesImportColumn;
use App\Libraries\ImportDescription;

class ImportColumn extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesImportColumn();
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
}
