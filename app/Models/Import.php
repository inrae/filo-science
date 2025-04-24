<?php

namespace App\Models;

use Ppci\Libraries\PpciException;

/**
 * Classe de gestion des imports csv
 * 
 * @author quinton
 *        
 */
class Import
{

    private $separator = ",";
    private $utf8_encode = false;
    private $handle;
    private $header = array();
    public $minuid, $maxuid;

    /**
     * Constructor
     * 
     * @param string  $filename
     * @param string  $separator
     * @param boolean $utf_encode
     */
    function __construct($filename, $separator = ",", $utf_encode = false, $fields = array())
    {
        $this->initFile($filename, $separator, $utf_encode, $fields);
    }

    /**
     * Init file function
     * Get the first line for header
     * 
     * @param string  $filename
     * @param string  $separator
     * @param boolean $utf8_encode
     * 
     * @throws ImportException
     */
    function initFile($filename, $separator = ",", $utf8_encode = false, $fields = array())
    {
        if ($separator == "tab" || $separator == "t") {
            $separator = "\t";
        }
        $this->separator = $separator;
        /*
         * File open
         */
        if ($this->handle = fopen($filename, 'r')) {
            $data = $this->readLine();
            $range = 0;
            /*
             * Headers preparation
             */
            for ($range = 0; $range < count($data); $range++) {
                if (in_array($data[$range], $fields) || substr($data[$range], 0, 3) == "md_") {
                    $this->header[$range] = $data[$range];
                } else {
                    throw new PpciException(sprintf(_("L'entête de colonne %1\$s n'est pas reconnue (%2\$s)"), $range, $data[$range]));
                }
            }
        } else {
            throw new PpciException(sprintf(_("%s non trouvé ou non lisible"), $filename));
        }
    }

    /**
     * Read a line
     *
     * @return array|NULL
     */
    function readLine()
    {
        if ($this->handle) {
            $data = fgetcsv($this->handle, 0, $this->separator);
            if ($data !== false && $this->utf8_encode) {
                foreach ($data as $key => $value) {
                    $data[$key] = mb_convert_encoding($value, 'UTF-8', 'ISO-8859-15, ISO-8859-1, Windows-1252');
                }
            }
            return $data;
        } else {
            return false;
        }
    }

    /**
     * Read the csv file, and return an associative array
     * 
     * @return mixed[][]
     */
    function getContentAsArray()
    {
        $data = array();
        $nb = count($this->header);
        while (($line = $this->readLine()) !== false) {
            $dl = array();
            for ($i = 0; $i < $nb; $i++) {
                $dl[$this->header[$i]] = $line[$i];
            }
            $data[] = $dl;
        }
        return $data;
    }

    /**
     * Close the file
     */
    function fileClose()
    {
        if ($this->handle) {
            fclose($this->handle);
        }
    }
}
