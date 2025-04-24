<?php
function verifyProject($project_id)
{
  $retour = false;
  if (isset($project_id )) {
    foreach ($_SESSION["projects"] as $value) {
      if ($project_id == $value["project_id"]) {
        $retour = true;
        break;
      }
    }
  }
  return $retour;
}