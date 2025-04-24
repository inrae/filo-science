<?php

namespace App\Libraries;

use App\Models\ImportColumn as ModelsImportColumn;
use App\Models\ImportDescription;
use Ppci\Libraries\PpciException;
use Ppci\Libraries\PpciLibrary;
use Ppci\Models\PpciModel;

class ImportColumn extends PpciLibrary
{
    /**
     * @var ModelsImportColumn
     */
    protected PpciModel $dataclass;


    function __construct()
    {
        parent::__construct();
        $this->dataclass = new ModelsImportColumn;
        $this->keyName = "import_column_id";
        if (isset($_REQUEST[$this->keyName])) {
            $this->id = $_REQUEST[$this->keyName];
        }
    }

    function change()
    {
        $this->vue = service('Smarty');
        $this->dataRead($this->id, "import/importColumnChange.tpl", $_REQUEST["import_description_id"]);
        /**
         * Get the list of columns usable during the import
         */
        $importDescription = new ImportDescription;
        $dDesc = $importDescription->getDetail($_REQUEST["import_description_id"]);
        $this->vue->set(explode(",", $dDesc["column_list"]), "columns");
        return $this->vue->send();
    }
    function write()
    {
        try {
            $this->id = $this->dataWrite($_REQUEST);
            $_REQUEST[$this->keyName] = $this->id;
            return true;
        } catch (PpciException $e) {
            return false;
        }
    }
    function delete()
    {
        try {
            $this->dataDelete($this->id);
            return true;
        } catch (PpciException $e) {
            return false;
        };
    }
}
