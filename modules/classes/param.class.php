<?php

/**
 * Generic class for all parameters tables with only 2 fields:
 * table name: test
 * field id: test_id
 * field name : field_name
 */
class Param extends ObjetBDD
{
    /**
     * Constructor
     *
     * @param pdo $bdd
     * @param string $tablename
     */
    function __construct($bdd, $tablename)
    {
        $this->table = $tablename;
        $this->colonnes = array(
            $tablename . "_id" => array("type" => 1, "requis" => 1, "key" => 1, "defaultValue" => 0),
            $tablename . "_name" => array("type" => 0, "requis" => 1)
        );
        parent::__construct($bdd);
    }
}
