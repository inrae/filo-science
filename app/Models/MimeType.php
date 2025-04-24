<?php

namespace App\Models;

use Ppci\Models\PpciModel;

class MimeType extends PpciModel
{

    /**
     * Constructeur de la classe
     *
     * @param 
     * @param array $param
     */
    function __construct()
    {
        $this->table = "mime_type";
        $this->fields = array(
            "mime_type_id" => array(
                "type" => 1,
                "key" => 1,
                "requis" => 1,
                "defaultValue" => 0
            ),
            "extension" => array(
                "type" => 0,
                "requis" => 1
            ),
            "content_type" => array(
                "type" => 0,
                "requis" => 1
            )
        );
        parent::__construct();
    }

    /**
     * Retourne le numero de type mime correspondant a l'extension
     *
     * @param string $extension
     * @return int
     */
    function getTypeMime($extension)
    {
        if (!empty($extension)) {
            $sql = "SELECT mime_type_id from mime_type where extension = :extension:";
            $res = $this->lireParamAsPrepared($sql, array("extension" => strtolower($extension)));
            return $res["mime_type_id"];
        }
    }
}
