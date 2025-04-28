<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\FeedCacheMap as LibrariesFeedCacheMap;

class FeedCacheMap extends PpciController
{
    protected $lib;
    function __construct()
    {
        $this->lib = new LibrariesFeedCacheMap();
    }
    function index()
    {
        return $this->lib->index();
    }
}
