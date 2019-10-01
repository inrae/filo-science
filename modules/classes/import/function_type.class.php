<?php

class FunctionTypeException extends Exception
{ }

/**
 * ORM of table function_type
 */
class FunctionType extends ObjetBDD
{

    /**
     * Class constructor.
     */
    public function __construct($bdd, $param = array())
    {
        $this->table = "function_type";
        $this->colonnes = array(
            "function_type_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "function_name" => array("type" => 0, "requis" => 1),
            "description" => array("type" => 0, "requis" => 1)
        );

        parent::__construct($bdd, $param);
    }
    /**
     * Get the description of a function
     *
     * @param integer $function_type_id
     * @return array
     */
    function getDescription (int $function_type_id):array {
        $sql = "select description from function_type where function_type_id = :id";
        return $this->lireParamAsPrepared($sql, array("id"=>$function_type_id));
    }

    /**
     * Function to call dynamic functions
     *
     * @param string $name
     * @param array $columns
     * @param array $args: must contains columnNumber and arg for the first argument, the others are free
     * @return any
     */
    public function functionCall($name, $columns, array $args = array())
    {
        if (is_callable(array($this, $name))) {
            return ($this->$name($columns, $args));
        } else {
            throw new FunctionTypeException(sprintf(_("La fonction %s n'est pas utilisable"), $name));
        }
    }
    /**
     * Test the content of a column
     *
     * @param array $columns
     * @param array $args
     * @return void
     */
    private function testValue(array $columns, array $args)
    {
        if ($columns[$args["columnNumber"]] != $args["arg"]) {
            throw new FunctionTypeException(sprintf(_("La colonne %s$1 ne correspond pas à la valeur attendue (%s$2)"), $args["columnNumber"], $args["arg"]));
        }
    }

    /**
     * Transform a hh:mm:ss.u in seconds.u
     *
     * @param array $columns
     * @param array $args
     * @return float
     */
    private function getSecondsFromTime(array $columns, array $args)
    {
        $time = split(":", $columns[$args["columnNumber"]]);
        if (count(time) != 3) {
            throw new FunctionTypeException(sprintf(_("La colonne %s n'est pas au format heure:minute:seconde")));
        }
        return ($time[0] * 3600 + $time[1] * 60 + $time[2]);
    }

    /**
     * Extract the n chars at the right of the column
     *
     * @param array $columns
     * @param array $args
     * @return string
     */
    private function extractRightChar(array $columns, array $args)
    {
        return substr($columns[$args["columnNumber"]], -$args["arg"]);
    }

    /**
     * Format the datetime and return it in SQL format
     *
     * @param array $columns
     * @param array $args
     * @return string
     */
    private function formatDateTime(array $columns, array $args)
    {
        $myDate = date_create_from_format($args["arg"], $columns[$args["columnNumber"]]);
        if (!$myDate) {
            throw new FunctionTypeException(sprintf(_("La valeur %s n'est pas reconnue comme une date valide"), $columns[$args["columnNumber"]]));
        }
        return $myDate->format("Y-m-d H:i:s");
    }
    /**
     * concatenate date and time
     *
     * @param array $columns
     * @param array $args
     * @return string
     */
    private function concatenateDateAndTime(array $columns, array $args)
    {
        return $columns[$args["columnNumber"]] . " " . $columns[$args["arg"]];
    }

    /**
     * Transform a number of days from a reference date to a date
     *
     * @param array $columns
     * @param array $args
     * @return string
     */
    private function transformJulianToDate(array $columns, array $args)
    {
        $myDate = date_create_from_format("Y-m-d", $args["arg"]);
        $nbdays = $columns[$args["columnNumber"]] - 1;
        $myDate->add(new DateInterval("P" + $nbdays + "D"));
        return $myDate->format("Y-m-d");
    }

    /**
     * Verify if a column is numeric
     *
     * @param array $columns
     * @param array $args
     * @return void
     */
    private function verifyTypeNumber(array $columns, array $args) {
        if (! is_numeric($columns[$args["columnNumber"]])) {
            throw new FunctionTypeException(sprintf(_("La colonne %s n'est pas numérique"), $args["columnNumber"]));
        }
    }
    /**
     * verify the number of columns
     *
     * @param array $columns
     * @param array $args
     * @return void
     */
    private function testColumnsNumber(array $columns, array $args) {
        if (count($columns) != $args["arg"]) {
            throw new FunctionTypeException(_("Le nombre de colonnes ne correspond pas à celui attendu"));
        }
    }
}
