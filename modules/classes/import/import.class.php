<?php

/**
 * ImportException class
 */
class ImportException extends Exception
{ }

/**
 * Open and read a csv file
 * 
 * @author quinton
 *        
 */
class Import
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
     * @throws ImportException
     */
    function initFile($filename, $separator = ",", $utf8_encode = false)
    {
        if ($separator == "tab" || $separator == "t") {
            $separator = "\t";
        } else if ($separator == "space") {
            $separator = " ";
        }
        $this->separator = $separator;
        /*
         * Ouverture du fichier
         */
        if (!$this->handle = fopen($filename, 'r')) {
            throw new ImportException(sprintf(_("Fichier %s non trouvé ou non lisible"), $filename));
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
            $line = fgets($this->handle);
            if ($this->separator == " ") {
                /**
                 * Drop consecutive spaces - not really a csv file
                 */
                $line = preg_replace('` {2,}`', '', $line);
            }
            $data = split($this->separator, $line);
            if ($data !== false && $this->utf8_encode) {
                foreach ($data as $key => $value) {
                    $data[$key] = utf8_encode($value);
                }
            }
            return $data;
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
