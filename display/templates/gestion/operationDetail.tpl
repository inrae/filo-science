<script>
    var mapIsChange = false;
</script>
<div class="row">
    <fieldset class="col-md-12">
        <legend>{t}Informations générales{/t}</legend>
        <div class="col-md-6">
            <a href="index.php?module=operationChange&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}">
                    <img src="{$display}/images/edit.gif" height="25">{t}Modifier{/t}
                </a>
            <div class="form-display">
                <dl class="dl-horizontal">
                    <dt>{t}Nom de l'opération :{/t}</dt>
                    <dd>{$data.operation_name}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Campagne :{/t}</dt>
                    <dd>{$data.campaign_name}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Station :{/t}</dt>
                    <dd>{$data.station_name}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Protocole :{/t}</dt>
                    <dd>{$data.protocol_name}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Mesure par défaut :{/t}</dt>
                    <dd>
                        {if $data["measure_default"] == "sl"}{t}Longueur standard{/t}
                        {elseif $data.measure_default == "fl"}{t}Longueur fourche{/t}
                        {elseif $data.measure_default == "tl"}{t}Longueur totale{/t}
                        {/if}
                    </dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Stratégie de pêche :{/t}</dt>
                    <dd>{$data.fishing_strategy_name}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Date/heure de début :{/t}</dt>
                    <dd>{$data.date_start}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Date/heure de fin :{/t}</dt>
                    <dd>{$data.date_end}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Opération en eau douce ?{/t}</dt>
                    <dd>{if $data.freshwater == 1}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Longitude/latitude de début :{/t}</dt>
                    <dd>{$data.long_start}<br>{$data.lat_start}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Longitude/latitude de fin :{/t}</dt>
                    <dd>{$data.long_end}<br>{$data.lat_end}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}PK depuis la source :{/t}</dt>
                    <dd>{$data.pk_source}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}PK depuis l'embouchure :{/t}</dt>
                    <dd>{$data.pk_mouth}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Longueur échantillonnée (en mètres) :{/t}</dt>
                    <dd>{$data.length}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Surface échantillonnée (m²) :{/t}</dt>
                    <dd>{$data.surface}</dd>
                </dl>

                <dl class="dl-horizontal">
                    <dt>{t}Emplacement (dans la rivière) :{/t}</dt>
                    <dd>{$data.side}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Altitude :{/t}</dt>
                    <dd>{$data.altitude}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Coefficient de marée :{/t}</dt>
                    <dd>{$data.tidal_coef}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Débit (m³/s) :{/t}</dt>
                    <dd>{$data.debit}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Régime d'eau :{/t}</dt>
                    <dd>{$data.water_regime_name}</dd>
                </dl>
                <dl class="dl-horizontal">
                    <dt>{t}Modèle de saisie :{/t}</dt>
                    <dd>{$data.taxa_template_name}</dd>
                </dl>
            </div>
        </div>
        <div class="col-md-6">
            <div id="map" class="mapDisplay">
                    {include file="gestion/operationMapChange.tpl"}
            </div>
        </div>
    </fieldset>
</div>