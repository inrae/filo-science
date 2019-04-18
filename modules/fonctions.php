<?php
/**
 * Fonctions specifiques de l'application, chargees systematiquement
 */

function verifiyProject($project_id)
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
