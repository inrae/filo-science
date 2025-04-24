<?php

namespace App\Models;

use Ppci\Libraries\PpciException;
use Ppci\Models\PpciModel;

/**
 * ORM of table function_type
 */
class FunctionType extends PpciModel
{
    private $transmitterIndividual = array();
    private $antennas = array();
    public IndividualTracking $individualTracking;
    /**
     * Class constructor.
     */
    public function __construct()
    {
        $this->table = "function_type";
        $this->fields = array(
            "function_type_id" => array("type" => 1, "key" => 1, "requis" => 1, "defaultValue" => 0),
            "function_name" => array("type" => 0, "requis" => 1),
            "description" => array("type" => 0, "requis" => 1)
        );
        parent::__construct();
    }
    /**
     * Get the description of a function
     *
     * @param integer $function_type_id
     * @return array
     */
    function getDescription(int $function_type_id): array
    {
        $sql = "SELECT description from function_type where function_type_id = :id:";
        return $this->lireParamAsPrepared($sql, array("id" => $function_type_id));
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
            if ($args["columnNumber"] > 0) {
                $args["columnNumber"]--;
            }
            return ($this->$name($columns, $args));
        } else {
            throw new PpciException(sprintf(_("La fonction %s n'est pas utilisable"), $name));
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
            throw new PpciException(sprintf(_('La colonne %1$s ne correspond pas à la valeur attendue (%2$s)'), $args["columnNumber"] + 1, $args["arg"]));
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
        $time = explode(":", $columns[$args["columnNumber"]]);
        if (count($time) != 3) {
            throw new PpciException(sprintf(_("La colonne %s n'est pas au format heure:minute:seconde"), $args["columnNumber"] + 1));
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
            throw new PpciException(sprintf(_("La valeur %s n'est pas reconnue comme une date valide"), $columns[$args["columnNumber"]]));
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
        return $columns[$args["columnNumber"]] . " " . $columns[$args["arg"] - 1];
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
        try {
            $myDate = date_create_from_format("Y-m-d", $args["arg"]);
            $nbdays = $columns[$args["columnNumber"]] - 1;
            $myDate->add(new \DateInterval("P" . $nbdays . "D"));
            return $myDate->format("Y-m-d");
        } catch (\Exception) {
            throw new PpciException(sprintf(_("La colonne %s n'est pas numérique"), $args["columnNumber"]));
        }
    }

    /**
     * Verify if a column is numeric
     *
     * @param array $columns
     * @param array $args
     * @return void
     */
    private function verifyTypeNumber(array $columns, array $args)
    {
        if (!is_numeric($columns[$args["columnNumber"]])) {
            throw new PpciException(sprintf(_("La colonne %s n'est pas numérique"), $args["columnNumber"] + 1));
        }
    }
    /**
     * verify the number of columns
     *
     * @param array $columns
     * @param array $args
     * @return void
     */
    private function testColumnsNumber(array $columns, array $args)
    {
        if (count($columns) != $args["arg"]) {
            throw new PpciException(_("Le nombre de colonnes ne correspond pas à celui attendu"));
        }
    }

    /**
     * Reformate a decimal field from comma to dot
     *
     * @param array $columns
     * @param array $args
     * @return float
     */
    private function transformDecimalSeparator(array $columns, array $args)
    {
        return str_replace(",", ".", $columns[$args["columnNumber"]]);
    }

    /**
     * Get the individual_id from the tag
     *
     * @param array $columns
     * @param array $args
     * @return int
     */
    private function getIndividualFromTag(array $columns, array $args)
    {
        $tagId = $columns[$args["columnNumber"]];
        if (!isset($this->transmitterIndividual[$tagId])) {
            if (!isset($this->individualTracking)) {
                $this->individualTracking = new IndividualTracking;
            }
            $dindividual = $this->individualTracking->getFromTag($tagId);
            if ($dindividual["individual_id"] > 0) {
                $this->transmitterIndividual[$tagId] = $dindividual["individual_id"];
            } else {
                throw new PpciException(sprintf(_("Le transmetteur %s ne correspond à aucun poisson connu"), $columns[$args["columnNumber"]]));
            }
        }
        return $this->transmitterIndividual[$tagId];
    }
    /**
     * Get the individual_id from the transmitter
     *
     * @param array $columns
     * @param array $args
     * @return int
     */
    private function getIndividualFromTransmitter(array $columns, array $args)
    {
        /**
         * Search if the transmitter is known
         */
        $transmitterId = $columns[$args["columnNumber"]];
        if (!isset($this->transmitterIndividual[$transmitterId])) {
            if (!isset($this->individualTracking)) {
                $this->individualTracking = new IndividualTracking;
            }
            $dindividual = $this->individualTracking->getFromTransmitter($transmitterId);
            if ($dindividual["individual_id"] > 0) {
                $this->transmitterIndividual[$transmitterId] = $dindividual["individual_id"];
            } else {
                throw new PpciException(sprintf(_("Le transmetteur %s ne correspond à aucun poisson connu"), $columns[$args["columnNumber"]]));
            }
        }
        return $this->transmitterIndividual[$transmitterId];
    }
    /**
     * Get the individual_id from the individual_code
     *
     * @param array $columns
     * @param array $args
     * @return int
     */
    private function getIndividualFromCode(array $columns, array $args)
    {
        $codeId = $columns[$args["columnNumber"]];
        if (!isset($this->transmitterIndividual[$codeId])) {
            if (!isset($this->individualTracking)) {
                $this->individualTracking = new IndividualTracking;
            }
            $dindividual = $this->individualTracking->getFromCode($codeId);
            if ($dindividual["individual_id"] > 0) {
                $this->transmitterIndividual[$codeId] = $dindividual["individual_id"];
            } else {
                throw new PpciException(sprintf(_("Le code %s ne correspond à aucun poisson connu"), $columns[$args["columnNumber"]]));
            }
        }
        return $this->transmitterIndividual[$codeId];
    }
    /**
     * Transform a numeric value to hexadecimal value
     *
     * @param array $columns
     * @param array $args
     * @return string
     */
    private function numericToHexa(array $columns, array $args)
    {
        $value = $columns[$args["columnNumber"]];
        if (is_numeric($value) && !empty($value)) {
            $format = "%0" . $args["arg"] . "s";
            return strtoupper(sprintf($format, dechex($value)));
        } else {
            return $value;
        }
    }

    /**
     * Concatenate columns or string
     * First value is the content of the columnNumber
     * arg is in json format: [{"type":"column","val":4},{type:"string","val":":"}]
     *
     * @param array $columns
     * @param array $args
     * @return void
     */
    private function concatenate(array $columns, array $args)
    {
        $value = $columns[$args["columnNumber"]];
        $fields = json_decode($args["arg"], true);
        if ($fields == NULL) {
            throw new PpciException(_("la fonction concatenate n'a pas pu interpréter l'argument au format JSON"));
        } else {
            foreach ($fields as $field) {
                $field["type"] == "col" ? $content = $columns[$field["val"]] : $content = $field["val"];
                $value .= $content;
            }
            return $value;
        }
    }
    /**
     * search a value corresponding to the data
     * arg contains a json array as {"valueSearched":correspondingValue, "2ndvalue":corresp2}
     *
     * @param array $columns
     * @param array $args
     * @return void
     */
    private function matchingCode(array $columns, array $args)
    {
        $value = "";
        $fields = json_decode($args["arg"], true);
        if ($fields == NULL) {
            throw new PpciException(_("la fonction matchingCode n'a pas pu interpréter l'argument au format JSON"));
        } else {
            $value = $fields[$columns[$args["columnNumber"]]];
        }
        if ($value == "") {
            throw new PpciException(sprintf(_("Aucune correspondance n'a pu être trouvée pour le paramètre %s"), $columns[$args["columnNumber"]]));
        }
        return $value;
    }
    /**
     * convert all data in the row in UTF-8
     *
     * @param array $columns
     * @param array $args
     * @return void
     */
    private function decodeAll(array $columns, array $args)
    {
        $result = array();
        foreach ($columns as $key => $column) {
            $val = mb_convert_encoding($column, "UTF-8", $args["arg"]);
            if (!$val) {
                throw new PpciException(_("Le décodage dans le jeu de caractères UTF-8 a échoué"));
            } else {
                $result[$key] = $val;
            }
        }
        return $result;
    }
    /**
     * Get the id of an antenna from its code
     *
     * @param array $columns
     * @param array $args
     * @return void
     */
    private function getAntennaFromCode(array $columns, array $args)
    {
        $value = $columns[$args["columnNumber"]];
        if (!isset($this->antennas[$value])) {
            global $antennaClass;
            if (!isset($antennaClass)) {
                throw new PpciException(_("Problème technique : la classe Antenna n'a pas été instanciée."));
            }
            $result = $antennaClass->getIdFromCode($value, $columns[$args["arg"] - 1]);
            if ($result == 0) {
                throw new PpciException(sprintf(_("Le code %s ne correspond à aucune antenne"), $value));
            } else {
                $this->antennas[$value] = $result;
            }
        }
        return $this->antennas[$value];
    }
}
