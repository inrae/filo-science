<?php
namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Taxon as LibrariesTaxon;

class Taxon extends PpciController {
protected $lib;
function __construct() {
$this->lib = new LibrariesTaxon();
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
function searchAjax() {
return $this->lib->searchAjax();
}
function lireAjax() {
return $this->lib->lireAjax();
}
function getListCode() {
return $this->lib->getListCode();
}
function getFromCode() {
return $this->lib->getFromCode();
}
}
