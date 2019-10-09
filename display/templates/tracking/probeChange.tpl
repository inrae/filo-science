<h2>{t}Création/Modification d'une sonde - station{/t}&nbsp;{$station.station_name}</h2>
<div class="row">
    <a href="index.php?module=stationTrackingList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    &nbsp;
    <a href="index.php?module=stationTrackingDisplay&station_id={$station.station_id}">
        <img src="display/images/display.png" height="25">
        {t}Retour à la station{/t}
    </a>
</div>
<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal protoform" id="probeForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="probe">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="station_id" value="{$data.station_id}">
            <input type="hidden" name="probe_id" value="{$data.probe_id}">
            <div class="form-group">
                <label for="probeCode"  class="control-label col-md-4"><span class="red">*</span> {t}Code de la sonde :{/t}</label>
                <div class="col-md-8">
                    <input id="probeCode" type="text" class="form-control" name="probe_code" value="{$data.probe_code}" autofocus required>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.probe_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>