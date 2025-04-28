<?php

namespace App\Libraries;

use Ppci\Libraries\PpciLibrary;

class FeedCacheMap extends PpciLibrary
{
    function index()
    {
        $this->vue = service("Smarty");
        $this->vue->set("param/feedCacheMap.tpl", "corps");
        setParamMap($this->vue);
        return $this->vue->send();
    }
}
