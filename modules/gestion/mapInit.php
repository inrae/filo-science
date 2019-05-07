<?php
/**
 * Iinitialisation of variables for display Openstreetmap maps
 */
foreach (array("mapDefaultX", "mapDefaultY", "mapDefaultZoom") as $field) {
    $vue->set($$field, $field);
}
