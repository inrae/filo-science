<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\ProtocolMeasure as LibrariesProtocolMeasure;

class ProtocolMeasure extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesProtocolMeasure();
}
function change() {
return $this->lib->change();
}
function write() {
if ($this->lib->write()) {
return $this->list();
} else {
return $this->change();
}
}
}
