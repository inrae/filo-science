<?php
namespace App\Models;

interface TelemetryImportInterface {
    function importData(array $data, bool $rewriteMode = false) ;
}