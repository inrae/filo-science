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
            $this->model[$m["tableName"]] = $m;
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
                $list[] = $table["tableName"];
            }
        }
        return $list;
    }
    /**
     * Get the content of a table
     *
     * @param string $tableName: name of the table
     * @param array $keys: list of the keys to extract
     * @param integer $parentKey: value of the technicalKey of the parent (foreign key)
     * @return array
     */
    function getTableContent(string $tableName, array $keys = array(), int $parentKey = 0): array
    {
        $content  = array();
        $args = array();
        $sql = "select * from $tableName";
        if (count($keys) > 0) {
            $where = " where " . $this->model[$tableName]["technicalKey"] . " in (";
            $comma = "";
            foreach ($keys as $k) {
                if (is_numeric($k)) {
                    $where .= $comma . $k;
                    $comma = ",";
                }
            }
            $where .= ")";
        } else if (strlen($this->model[$tableName]["parentKey"]) > 0 && $parentKey > 0) {
            /**
             * Search by parent
             */
            $where = " where " . $this->model[$tableName]["parentKey"] . " = :parentKey";
            $args["parentKey"] = $parentKey;
        } else {
            $where = "";
        }
        $order = " order by " . $this->model[$tableName]["technicalKey"];
        $content = $this->execute($sql . $where . $order, $args);
        /**
         * Search the data from the children
         */
        if (count($this->model[$tableName]["children"]) > 0) {
            foreach ($content as $k => $row) {
                foreach ($this->model[$tableName]["children"] as $child) {
                    $content[$k]["children"][$child] = $this->getTableContent($child, array(), $row[$this->model[$tableName]["technicalKey"]]);
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
     * @return void
     */
    function importDataTable(string $tableName, array $data, int $parentKey = 0)
    {
        if (!isset($this->model[$tableName])) {
            throw new ExportException(sprintf(_("Aucune description trouvée pour la table %s dans le fichier de paramètres"), $tableName));
        }
        /**
         * prepare sql request for search key
         */
        $bkeyName = $this->model[$tableName]["businessKey"];
        $tkeyName = $this->model[$tableName]["technicalKey"];
        $pkeyName = $this->model[$tableName]["parentKey"];
        if (strlen($bkeyName) > 0) {
            $sqlSearchKey = "select $tkeyName as key
                    from $tableName
                    where $bkeyName = :businessKey";
            $isBusiness = true;
        } else {
            $isBusiness = false;
        }
        foreach ($data as $key => $row) {
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
    function writeData(string $tableName, array $data): int
    {
        $tkeyName = $this->model[$tableName]["technicalKey"];
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
        printr($sql);
        printr($dataSql);
        $result = $this->execute($sql, $dataSql);
        if ($mode == "insert") {
            $newKey = $result[0][$tkeyName];
        } else {
            $newKey = $data[$tkeyName];
        }
        return $newKey;
    }
}
