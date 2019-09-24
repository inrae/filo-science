<div class="row">
    <div class="col-md-6 form-display">
        <dl class="dl-horizontal">
            <dt>{t}Nom de la station :{/t}</dt>
            <dd>{$data.station_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Projet :{/t}</dt>
            <dd>{$data.project_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Type de station :{/t}</dt>
            <dd>{$data.station_type_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Code de la station :{/t}</dt>
            <dd>{$data.station_code}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Cours d'eau :{/t}</dt>
            <dd>{$data.river_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Longitude :{/t}</dt>
            <dd>{$data.station_long}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Latitude :{/t}</dt>
            <dd>{$data.station_lat}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Pk :{/t}</dt>
            <dd>{$data.station_pk}</dd>
        </dl>
    </div>
    <div class="col-md-6">
        {include file="param/stationMap.tpl"}
    </div>
</div>