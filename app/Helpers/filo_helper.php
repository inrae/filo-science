<?php

namespace App\Libraries;

use App\Models\Param;
use Ppci\Libraries\PpciException;

function verifyProject($project_id)
{
    $retour = false;
    if (isset($project_id)) {
        foreach ($_SESSION["projects"] as $value) {
            if ($project_id == $value["project_id"]) {
                $retour = true;
                break;
            }
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
    try {

        $iclass = new Param($tablename);
        $vue->set($iclass->getListe(2), $tablename . "s");
        unset($iclass);
    } catch (PpciException $e) {
        $message = service("MessagePpci");
        $message->set(sprintf(_("Problème de récupération des paramètres de la table %s"), $tablename), true);
        $message->setSyslog($e->getMessage());
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
        foreach (
            array(
                "mapDefaultZoom",
                "mapDefaultLong",
                "mapDefaultLat",
                "mapCacheMaxAge",
                "mapSeedMinZoom",
                "mapSeedMaxZoom",
                "mapSeedMaxAge",
                "mapMinZoom",
                "mapMaxZoom"
            ) as $mapParam
        ) {
            if (isset($_SESSION["dbparams"][$mapParam])) {
                $vue->set($_SESSION["dbparams"][$mapParam], $mapParam);
            }
        }
        if ($isChange) {
            $vue->set("edit", "mapMode");
        }
    }
}

function feedCacheMap($vue)
{
    $vue->set("param/feedCacheMap.tpl", "corps");
    setParamMap($vue);
}
