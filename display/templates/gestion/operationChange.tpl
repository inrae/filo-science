
<script>
var mapIsChange = true;    
$(document).ready(function() {
    
    $("#station_id").change(function() { 
        var stationId = $(this).val();
        if (stationId > 0) {
            var options = "";
            var url = "index.php";
            var data = { "module": "stationGetCoordinate",
                        "station_id":stationId
                    };
            $.ajax( {
                url: "index.php",
                data: data
            })
            .done (function(data) {
                var result = JSON.parse(data);
                $("#long_start").val(result["station_long"]);
                $("#lat_start").val(result["station_lat"]);
                coordChange();
            });
        }
    });
    /*
     * function for put points on map
     */
    function coordChange() {
    var long_deb = $('#long_start').val();
		var lat_deb = $('#lat_start').val();
		var long_fin = $('#long_end').val();
        var lat_fin = $('#lat_end').val();
        /*console.log("long:"+long_deb);
        console.log("lat:"+lat_deb);
        console.log("longend:"+long_fin);
        console.log("latend:"+lat_fin);*/
    if (long_deb.length > 0 && lat_deb.length > 0) {
			 setPosition(1, long_deb, lat_deb);
		 }
		if (long_fin.length > 0 && lat_fin.length > 0) {
			setPosition(2, long_fin, lat_fin);
        }
    }
    $(".coord").change(function() {
        coordChange();
    });
    /* Initialisation of map */
    coordChange();
});
</script>

<h2>{t}Création - Modification d'une opération{/t}</h2>
<a href="index.php?module=campaignDisplay&campaign_id={$data.campaign_id}"><img src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t}</a>
{if $data.operation_id > 0}
    <a href="index.php?module=operationDisplay&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}"><img src="display/images/display-green.png" height="25">{t}Retour à l'opération{/t}</a>
{/if}
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="operation">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="operation_id" value="{$data.operation_id}">
            <div class="form-group">
                <label for="paramName"  class="control-label col-md-4"> {t}Nom de l'opération :{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                    <input id="paramName" type="text" class="form-control" name="operation_name" value="{$data.operation_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="campaign_id"  class="control-label col-md-4"> {t}Campagne de rattachement :{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                    <input id="campaign_id" type="hidden" name="campaign_id" value="{$data.campaign_id}">
                    <input id="campaign_name" name="campaign_name" class="form-control" value="{$data.campaign_name}" disabled>
                </div>
            </div>
            <div class="form-group">
                <label for="station_id"  class="control-label col-md-4">{t}Station :{/t}</label>
                <div class="col-md-8">
                    <select id="station_id" name="station_id" class="form-control">
                        <option value ="" {if $row.station_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
                    {foreach $stations as $row}
                        <option value="{$row.station_id}" {if $row.station_id == $data.station_id}selected{/if}>
                        {$row.station_name}{if strlen($row.river_name) > 0} ({$row.river_name}){/if}
                        </option>
                    {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="protocol_id"  class="control-label col-md-4"> {t}Protocole utilisé :{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                    <select id="protocol_id" name="protocol_id" class="form-control">
                        {foreach $protocols as $row}
                            <option value="{$row.protocol_id}" {if $row.protocol_id == $data.protocol_id}selected{/if}>
                            {$row.protocol_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="fishing_strategy_id"  class="control-label col-md-4">{t}Stratégie de pêche :{/t}</label>
                <div class="col-md-8">
                    <select id="fishing_strategy_id" name="fishing_strategy_id" class="form-control">
                        <option value ="" {if $row.fishing_strategy_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
                        {foreach $fishing_strategys as $row}
                            <option value="{$row.fishing_strategy_id}" {if $row.fishing_strategy_id == $data.fishing_strategy_id}selected{/if}>
                            {$row.fishing_strategy_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="date_start"  class="control-label col-md-4"> {t}Date/heure de début :{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                    <input id="date_start" name="date_start" class="form-control datetimepicker" value="{$data.date_start}" required>
                </div>   
            </div>        
            <div class="form-group">
                <label for="date_end"  class="control-label col-md-4"> {t}Date/heure de fin :{/t}</label>
                <div class="col-md-8">
                    <input id="date_end" name="date_end" class="form-control datetimepicker" value="{$data.date_end}" >
                </div>   
            </div>        
            <div class="form-group">
                <label for="freshwater"  class="control-label col-md-4"> {t}Opération réalisée en eau douce ?{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                      <label class="radio-inline">
                        <input  type="radio" name="freshwater" id="freshwater1" value="1" {if $data.freshwater == 1}checked{/if}>
                        {t}oui{/t}
                    </label>
                    <label class="radio-inline">
                        <input  type="radio" name="freshwater" id="freshwater2" value="0" {if $data.freshwater == 0}checked{/if}>
                        {t}non{/t}
                    </label>
               </div>   
            </div>        
            <div class="form-group">
                <label for="long_start"  class="control-label col-md-4"> {t}Longitude de départ :{/t}</label>
                <div class="col-md-8">
                    <input id="long_start" name="long_start" class="form-control taux coord" value="{$data.long_start}">
                </div>
            </div>
            <div class="form-group">
                <label for="lat_start"  class="control-label col-md-4"> {t}Latitude de départ :{/t}</label>
                <div class="col-md-8">
                    <input id="lat_start" name="lat_start" class="form-control taux coord" value="{$data.lat_start}">
                </div>
            </div>
            <div class="form-group">
                <label for="long_end"  class="control-label col-md-4"> {t}Longitude de fin :{/t}</label>
                <div class="col-md-8">
                    <input id="long_end" name="long_end" class="form-control taux coord" value="{$data.long_end}">
                </div>
            </div>
            <div class="form-group">
                <label for="lat_end"  class="control-label col-md-4"> {t}Latitude de fin :{/t}</label>
                <div class="col-md-8">
                    <input id="lat_end" name="lat_end" class="form-control taux coord" value="{$data.lat_end}">
                </div>
            </div>
            <div class="form-group">
                <label for="pk_source"  class="control-label col-md-4"> {t}PK depuis la source :{/t}</label>
                <div class="col-md-8">
                    <input id="pk_source" name="pk_source" class="form-control taux" value="{$data.pk_source}">
                </div>
            </div>
            <div class="form-group">
                <label for="pk_mouth"  class="control-label col-md-4"> {t}PK depuis l'embouchure :{/t}</label>
                <div class="col-md-8">
                    <input id="pk_mouth" name="pk_mouth" class="form-control taux" value="{$data.pk_mouth}">
                </div>
            </div>         
            <div class="form-group">
                <label for="length"  class="control-label col-md-4"> {t}Longueur échantillonnée (en mètres) :{/t}</label>
                <div class="col-md-8">
                    <input id="length" name="length" class="form-control taux" value="{$data.length}">
                </div>
            </div>            
            <div class="form-group">
                <label for="surface"  class="control-label col-md-4"> {t}Surface échantillonnée (en m²) :{/t}</label>
                <div class="col-md-8">
                    <input id="surface" name="surface" class="form-control taux" value="{$data.surface}">
                </div>
            </div>
            <div class="form-group">
                <label for="side"  class="control-label col-md-4"> {t}Emplacement (dans la rivière) :{/t}</label>
                <div class="col-md-8">
                    <input id="side" name="side" class="form-control" value="{$data.side}">
                </div>
            </div>
            <div class="form-group">
                <label for="altitude"  class="control-label col-md-4"> {t}Altitude :{/t}</label>
                <div class="col-md-8">
                    <input id="altitude" name="altitude" class="form-control taux" value="{$data.altitude}">
                </div>
            </div>
            <div class="form-group">
                <label for="tidal_coef"  class="control-label col-md-4"> {t}Coefficient de marée :{/t}</label>
                <div class="col-md-8">
                    <input id="tidal_coef" name="tidal_coef" class="form-control nombre" value="{$data.tidal_coef}">
                </div>
            </div>
            <div class="form-group">
                <label for="debit"  class="control-label col-md-4"> {t}Débit (m³/s) :{/t}</label>
                <div class="col-md-8">
                    <input id="debit" name="debit" class="form-control taux" value="{$data.debit}">
                </div>
            </div>
            <div class="form-group">
                <label for="water_regime_id"  class="control-label col-md-4">{t}Régime d'eau :{/t}</label>
                <div class="col-md-8">
                    <select id="water_regime_id" name="water_regime_id" class="form-control">
                        <option value ="" {if $row.water_regime_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
                        {foreach $water_regimes as $row}
                            <option value="{$row.water_regime_id}" {if $row.water_regime_id == $data.water_regime_id}selected{/if}>
                            {$row.water_regime_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="taxa_template_id"  class="control-label col-md-4">{t}Grille de sélection des taxons :{/t}</label>
                <div class="col-md-8">
                    <select id="taxa_template_id" name="taxa_template_id" class="form-control">
                        <option value ="" {if $row.taxa_template_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
                        {foreach $taxa_templates as $row}
                            <option value="{$row.taxa_template_id}" {if $row.taxa_template_id == $data.taxa_template_id}selected{/if}>
                            {$row.taxa_template_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.operation_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
    <div class="col-md-6">
        <div id="map" class="mapDisplay">
                {include file="gestion/operationMapChange.tpl"}
        </div>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>