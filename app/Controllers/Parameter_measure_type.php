<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Parameter_measure_type as LibrariesParameter_measure_type;

class Parameter_measure_type extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesParameter_measure_type();
}
function list() {
return $this->lib->list();
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
function delete() {
if ($this->lib->delete()) {
return $this->list();
} else {
return $this->change();
}
}
}
