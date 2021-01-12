<script>
    var mapIsChange = true;
</script>
<h2>{t}Création - Modification d'une station{/t}</h2>
<a href="index.php?module=stationList">
    <img src="display/images/list.png" height="25">
    {t}Retour à la liste{/t}
</a>
<div class="row">
    <div class="col-md-6">


        <form class="form-horizontal protoform" id="stationForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="station">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="station_id" value="{$data.station_id}">
            <div class="form-group">
                <label for="stationName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
                <div class="col-md-8">
                    <input id="stationName" type="text" class="form-control" name="station_name" value="{$data.station_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="stationCode"  class="control-label col-md-4">{t}Code métier :{/t}</label>
                <div class="col-md-8">
                    <input id="stationCode" type="text" class="form-control" name="station_code" value="{$data.station_code}">
                </div>
            </div>
            <div class="form-group">
                <label for="stationNumber"  class="control-label col-md-4">{t}N° métier :{/t}</label>
                <div class="col-md-8">
                    <input id="stationNumber" type="text" class="form-control taux" name="station_number" value="{$data.station_number}">
                </div>
            </div>
            <div class="form-group">
                <label for="project_id"  class="control-label col-md-4">{t}Projet de rattachement :{/t}</label>
                <div class="col-md-8">
                    <select id="project_id" name="project_id" class="form-control">
                        <option value="" {if $data["project_id"] == ""} selected{/if}>{t}Choisissez...{/t}</option>
                        {foreach $projects as $project}
                            <option value="{$project.project_id}" {if $project.project_id == $data.project_id} selected {/if}>
                                {$project.project_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="river_id"  class="control-label col-md-4">{t}Cours d'eau :{/t}</label>
                <div class="col-md-8">
                    <select id="river_id" name="river_id" class="form-control">
                        <option value="" {if $data["river_id"] == ""} selected{/if}>{t}Choisissez...{/t}</option>
                        {foreach $rivers as $river}
                            <option value="{$river.river_id}" {if $river.river_id == $data.river_id} selected {/if}>
                                {$river.river_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="station_long"  class="control-label col-md-4">{t}Longitude :{/t}</label>
                <div class="col-md-8">
                    <input id="station_long" type="text" class="form-control taux position" name="station_long" value="{$data.station_long}">
                </div>
            </div>
            <div class="form-group">
                <label for="station_lat"  class="control-label col-md-4">{t}Latitude :{/t}</label>
                <div class="col-md-8">
                    <input id="station_lat" type="text" class="form-control taux position" name="station_lat" value="{$data.station_lat}">
                </div>
            </div>
            <div class="form-group">
                <label for="station_pk"  class="control-label col-md-4">{t}PK :{/t}</label>
                <div class="col-md-8">
                    <input id="station_pk" type="text" class="form-control taux" name="station_pk" value="{$data.station_pk}">
                </div>
            </div>


            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.station_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
    <div class="col-md-6">
    {include file="param/stationMap.tpl"}
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
