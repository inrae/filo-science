<h2>{t}Création/Modification d'une antenne - station{/t}&nbsp;{$station.station_name}</h2>
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
                <label for="technology_type_id" class="control-label col-md-4"><span class="red">*</span> {t}Technologie employée :{/t}</label>
                <div class="col-md-8">
                    <select class="form-control" id="technology_type_id" name="technology_type_id">
                        {foreach $technologies as $technology}
                            <option value="{$technology.technology_type_id}" {if $technology.technology_type_id == $data.technology_type_id}selected{/if}>
                                {$technology.technology_type_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="radius"  class="control-label col-md-4">{t}Rayon de réception (en mètres) :{/t}</label>
                <div class="col-md-8">
                    <input id="radius" type="text" class="form-control" name="radius" value="{$data.radius}">
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