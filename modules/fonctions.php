<?php

/**
 * Fonctions specifiques de l'application, chargees systematiquement
 */

/**
 * Verify if the project is authorized for the user
 *
 * @param int $project_id
 * @return boolean
 */
function verifyProject($project_id)
{
    $retour = false;
    foreach ($_SESSION["projects"] as $value) {
        if ($project_id == $value["project_id"]) {
            $retour = true;
            break;
        }
    }
    return $retour;
}
/**
 * Populate the content of a parameter table to the vue
 *
 * @param Vue $vue
 * @param string $tablename: name of the parameter table
 * @return void
 */
function setParamToVue($vue, $tablename)
{
    global $bdd, $message;
    try {
        include_once "modules/classes/param.class.php";
        $iclass = new Param($bdd, $tablename);
        $vue->set($iclass->getListe(2), $tablename . "s");
        unset($iclass);
    } catch (Exception $e) {
        $message->set(sprintf(_("Problème de récupération des paramètres de la table %s"), $tablename), true);
        $message->setSyslog($e->getMessage);
    }
}
/**
 * Set defaults parameters for maps to vue
 *
 * @param Vue $vue
 * @param boolean $isChange
 * @return void
 */
function setParamMap($vue, $isChange = false)
{
    if (isset($vue)) {
        foreach (array(
            "mapDefaultZoom",
            "mapDefaultLong",
            "mapDefaultLat",
            "mapCacheMaxAge",
            "mapSeedMinZoom",
            "mapSeedMaxZoom",
            "mapSeedMaxAge",
            "mapMinZoom",
            "mapMaxZoom"
        ) as $mapParam) {
            if (isset($_SESSION[$mapParam])) {
                $vue->set($_SESSION[$mapParam], $mapParam);
            } else {
                global $$mapParam;
                $vue->set($$mapParam, $mapParam);
            }
        }
        if ($isChange) {
            $vue->set("edit", "mapMode");
        }
    }
}
