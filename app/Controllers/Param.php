<?php

namespace App\Controllers;

use \Ppci\Controllers\PpciController;
use App\Libraries\Param as LibrariesParam;

class Param extends PpciController
{
    protected $lib;
    private $comments = [];

    function __construct()
    {
        $this->comments = [
            "granulometry" => _("Classes de granulométrie"),
            "speed" => _("Classes de vitesse de courant"),
            "shady" => _("Types d'ombrage"),
            "clogging" => _("Types de colmatages"),
            "facies" => _("Types de faciès"),
            "sinuosity" => _("Types de sinuosités de la rivière"),
            "localisation" => _("Localisation de l'opération de pêche"),
            "situation" => _("Liste des emplacements particuliers"),
            "vegetation" => _("Types de végétation"),
            "turbidity" => _("Classes de turbidité"),
            "flow_trend" => _("Évolutions du débit"),
            "cache_abundance" => _("Classes d'abondance des caches"),
            "fishing_strategy" => _("Stratégies d'échantillonnage"),
            "scale" => _("Échelles d'échantillonnage"),
            "electric_current_type" => _("Types de courant électrique"),
            "gear_method" => _("Méthodes d'utilisation des engins"),
            "river" => _("Cours d'eau"),
            "station_type" => _("Types de stations"),
            "antenna_type" => _("Types d'antennes (détection individuelle"),
            "technology_type" => _("Méthodes d'utilisation des engins"),
        ];
    }

    function list($table)
    {
        $this->initLibrary($table);
        return $this->lib->list();
    }
    function change($table)
    {
        $this->initLibrary($table);
        return $this->lib->change();
    }
    function write($table)
    {
        $this->initLibrary($table);
        if ($this->lib->write()) {
            return $this->lib->list();
        } else {
            return $this->lib->change();
        }
    }
    function delete($table)
    {
        $this->initLibrary($table);
        if ($this->lib->delete()) {
            return $this->lib->list();
        } else {
            return $this->lib->change();
        }
    }
    function initLibrary($table)
    {
        $this->lib = new LibrariesParam($table, $this->comments[$table]);
    }
}
