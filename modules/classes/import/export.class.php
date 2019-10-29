<?php
class ExportException extends Exception
{ };

class Export
{
    private $model = array();
    private $bdd;
    private $lastResultExec;
    /**
     * Constructor
     *
     * @param PDO $bdd: database connection object
     */
    function __construct(PDO $bdd)
    {
        $this->bdd = $bdd;
    }

    /**
     * Set the used model
     *
     * @param string $model: JSON field contents the description of the tables
     * @return void
     */
    function initModel(string $model)
    {
        $model = json_decode($model, true);
        /**
         * Generate the model with tableName as identifier
         */
        foreach ($model as $m) {
            /**
             * Set the tableAlias if not defined
             */
            if (strlen($m["tableAlias"]) == 0) {
                $m["tableAlias"] = $m["tableName"];
            }
            $this->model[$m["tableAlias"]] = $m;
        }
    }
    /**
     * Get the list of the tables witch are not children
     *
     * @return array
     */
    function getListPrimaryTables(): array
    {
        $list = array();
        foreach ($this->model as $table) {
            if (strlen($table["parentKey"]) == 0) {
                $list[] = $table["tableAlias"];
            }
        }
        return $list;
    }
    /**
     * Get the content of a table
     *
     * @param string $tableName: alias of the table
     * @param array $keys: list of the keys to extract
     * @param integer $parentKey: value of the technicalKey of the parent (foreign key)
     * @return array
     */
    function getTableContent(string $tableAlias, array $keys = array(), int $parentKey = 0): array
    {
        $model = $this->model[$tableAlias];
        $tableName = $model["tableName"];
        $content  = array();
        $args = array();
        $sql = "select * from $tableName";
        if (count($keys) > 0) {
            $where = " where " . $model["technicalKey"] . " in (";
            $comma = "";
            foreach ($keys as $k) {
                if (is_numeric($k)) {
                    $where .= $comma . $k;
                    $comma = ",";
                }
            }
            $where .= ")";
        } else if (strlen($model["parentKey"]) > 0 && $parentKey > 0) {
            /**
             * Search by parent
             */
            $where = " where " . $model["parentKey"] . " = :parentKey";
            $args["parentKey"] = $parentKey;
        } else {
            $where = "";
        }
        if (strlen($model["technicalKey"]) > 0) {
            $order = " order by " . $model["technicalKey"];
        } else {
            $order = " order by 1";
        }
        $content = $this->execute($sql . $where . $order, $args);
        /**
         * Search the data from the children
         */
        if (count($model["children"]) > 0) {
            foreach ($content as $k => $row) {
                foreach ($model["children"] as $child) {
                    $content[$k]["children"][$child] = $this->getTableContent($child, array(), $row[$model["technicalKey"]]);
                }
            }
        }
        return $content;
    }

    /**
     * Execute a SQL command
     *
     * @param string $sql: request to execute
     * @param array $data: data associated with the request
     * @return array
     */
    function execute(string $sql, array $data = array()): array
    {
        try {
            $stmt = $this->bdd->prepare($sql);
            $this->lastResultExec = $stmt->execute($data);
            if ($this->lastResultExec) {
                return $stmt->fetchAll(PDO::FETCH_ASSOC);
            }
        } catch (PDOException $e) {
            $this->lastResultExec = false;
            throw new ExportException($e->getMessage());
        }
    }

    /**
     * Import data from a table
     *
     * @param string $tableName: name of the table
     * @param array $data: all data to be recorded
     * @param integer $parentKey: key of the parent from the table
     * @param array $setValues: list of values to insert into each row. Used for set a parent key
     * @return void
     */
    function importDataTable(string $tableAlias, array $data, int $parentKey = 0, array $setValues = array())
    {
        if (!isset($this->model[$tableAlias])) {
            throw new ExportException(sprintf(_("Aucune description trouvée pour l'alias de table %s dans le fichier de paramètres"), $tableAlias));
        }
        /**
         * prepare sql request for search key
         */
        $model = $this->model[$tableAlias];
        $tableName = $model["tableName"];
        $bkeyName = $model["businessKey"];
        $tkeyName = $model["technicalKey"];
        $pkeyName = $model["parentKey"];
        if (strlen($bkeyName) > 0) {
            $sqlSearchKey = "select $tkeyName as key
                    from $tableName
                    where $bkeyName = :businessKey";
            $isBusiness = true;
        } else {
            $isBusiness = false;
        }
        foreach ($data as $row) {
            /**
             * search for preexisting record
             */
            if ($isBusiness && strlen($row[$bkeyName]) > 0) {
                $previousData = $this->execute($sqlSearchKey, array("businessKey" => $row[$bkeyName]));
                if ($previousData[0]["key"] > 0) {
                    $row[$tkeyName] = $previousData[0]["key"];
                } else {
                    unset($row[$tkeyName]);
                }
            } else {
                unset($row[$tkeyName]);
            }
            if ($parentKey > 0 && strlen($pkeyName) > 0) {
                $row[$pkeyName] = $parentKey;
            }
            /**
             * Set values
             */
            if (count($setValues) > 0) {
                foreach ($setValues as $kv => $dv) {
                    $row[$kv] = $dv;
                }
            }
            /**
             * Write data
             */
            $children = $row["children"];
            unset($row["children"]);
            $id = $this->writeData($tableName, $row);
            /**
             * Record the children
             */
            if ($id > 0) {
                foreach ($children as $tableChield => $child) {
                    $this->importDataTable($tableChield, $child, $id);
                }
            }
        }
    }

    /**
     * insert or update a record
     *
     * @param string $tableName: name of the table
     * @param array $data: data of the record
     * @return integer: technical key generated or updated
     */
    function writeData(string $tableAlias, array $data): int
    {
        $model = $this->model[$tableAlias];
        $tableName = $model["tableName"];
        $tkeyName = $model["technicalKey"];
        $dataSql = array();
        $comma = "";
        $quote = '"';
        if ($data[$tkeyName] > 0) {
            /**
             * update
             */
            $mode = "update";
            $sql = "update $tableName set ";
            foreach ($data as $field => $value) {
                if ($field != $tkeyName) {
                    $sql .= "$comma$quote$field$quote = :$field";
                    $comma = ", ";
                }
                $where = " where $quote$tkeyName$quote = :$tkeyName";
                $dataSql[$field] = $value;
            }
            if (!isset($where)) {
                throw new ExportException(sprintf(_("la clause where n'a pu être construite pour la table %s"), $tableName));
            }
            $sql .= $where;
        } else {
            /**
             * insert
             */
            $mode = "insert";
            $cols = "(";
            $values = "(";
            foreach ($data as $field => $value) {
                $cols .= $comma . $quote . $field . $quote;
                $values .= $comma . ":$field";
                $dataSql[$field] = $value;
                $comma = ", ";
            }
            $cols .= ")";
            $values .= ")";
            $sql = "insert into $tableName $cols values $values RETURNING $tkeyName";
        }
        $result = $this->execute($sql, $dataSql);
        if ($mode == "insert") {
            $newKey = $result[0][$tkeyName];
        } else {
            $newKey = $data[$tkeyName];
        }
        return $newKey;
    }
}
