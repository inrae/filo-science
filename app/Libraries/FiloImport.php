<?php

namespace App\Libraries;

use Ppci\Libraries\PpciException;

class FiloImport
{
    private $separator = ",";
    private $utf8_encode = false;
    private $handle;

    /**
     * Open the file
     *
     * @param string $filename
     * @param string $separator
     * @param bool $utf8_encode
     *
     * @return array
     */
    function readFile(string $filename, string $separator = ",", bool $utf8_encode = false): array
    {
        $this->initFile($filename, $separator, $utf8_encode);
        $data = array();
        while (($line = $this->readLine()) !== false) {
            $data[] = $line;
        }
        $this->fileClose();
        return $data;
    }

    /**
     * Fonction d'initialisation du fichier
     *
     * @param string  $filename
     * @param string  $separator
     * @param boolean $utf8_encode
     *
     * @throws PpciException
     */
    function initFile($filename, $separator = ",", $utf8_encode = false)
    {
        if ($separator == "tab" || $separator == "t") {
            $separator = "\t";
        } else if ($separator == "space") {
            $separator = " ";
        }
        $this->separator = $separator;
        $this->utf8_encode = $utf8_encode;
        /*
         * Ouverture du fichier
         */
        $filename = str_replace ("../", "", $filename);
        if (!$this->handle = fopen($filename, 'r')) {
            throw new PpciException(sprintf(_("Fichier %s non trouvé ou non lisible"), $filename));
        }
    }

    /**
     * Read a line in the file
     *
     * @return array|bool
     */
    function readLine()
    {
        if ($this->handle) {
            try {
                $line = fgets($this->handle);
                if ($line !== false) {
                    if ($this->separator == " ") {
                        /**
                         * Drop consecutive spaces - not really a csv file
                         */
                        $line = preg_replace('/\s+/', ' ', $line);
                    }
                    $data = explode($this->separator, $line);
                    if ($data !== false && $this->utf8_encode) {
                        foreach ($data as $key => $value) {
                            $data[$key] = mb_convert_encoding($value, 'UTF-8', 'ISO-8859-15, ISO-8859-1, Windows-1252');
                        }
                    }
                    return $data;
                } else {
                    return false;
                }
            } catch (PpciException $e) {
                throw new PpciException($e->getMessage());
            }
        } else {
            return false;
        }
    }

    /**
     * Close the file
     *
     * @return void
     */
    function fileClose()
    {
        if ($this->handle) {
            fclose($this->handle);
        }
    }
}
