<h2>{t}Création/Modification d'une antenne - station{/t}&nbsp;{$station.station_name}</h2>
<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal protoform" id="stationForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="antenna">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="station_id" value="{$data.station_id}">
            <input type="hidden" name="antenna_id" value="{$data.antenna_id}">
            <div class="form-group">
                <label for="antennaCode"  class="control-label col-md-4"><span class="red">*</span> {t}Code de l'antenne :{/t}</label>
                <div class="col-md-8">
                    <input id="antennaCode" type="text" class="form-control" name="antenna_code" value="{$data.antenna_code}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="diameter"  class="control-label col-md-4">{t}Diamètre de réception (en mètres) :{/t}</label>
                <div class="col-md-8">
                    <input id="diameter" type="text" class="form-control" name="diameter" value="{$data.diameter}" autofocus required>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.antenna_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>