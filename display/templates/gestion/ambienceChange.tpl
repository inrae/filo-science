<script type="text/javascript" src="display/javascript/formbuilder.js"></script>
<script>
    var mapIsChange = true;
$(document).ready(function(){
    function setPos() {
        var lon = $("#ambience_long").val();
        var lat = $("#ambience_lat").val();
        setPositionA(lat, lon);
    };
    $(".position").change(function () {
        setPos();
    });
    /*
     * Initialisation of map
     */
    setPos();
    /*
     * complementary measures
     */
    $("#paramForm").submit(function(event) {
        if ($("#action").val()=="Write"){
            var error = false;
            $('#metadata').alpaca().refreshValidationState(true);
            if($('#metadata').alpaca().isValid()){
                var value = $('#metadata').alpaca().getValue();
                // met les metadata en JSON dans le champ qui sera sauvegardé en base
                $("#metadataField").val(JSON.stringify(value));
            } else {
                console.log("Error in analysis of metadata");
                error = true;
            }
            if (error) {
                event.preventDefault();
            }
        }
    });
    var dataParse = $("#metadataField").val();
    dataParse = dataParse.replace(/&quot;/g,'"');
    dataParse = dataParse.replace(/\n/g,"\\n");
    if (dataParse.length > 2) {
        dataParse = JSON.parse(dataParse);
    }
    var schema = "{$ambience_template_schema}";
    if (schema.length > 0) {
        schema = schema.replace(/&quot;/g,'"');
        showForm(JSON.parse(schema),dataParse);
    }
});
</script>
<div class="row">
    <a href="index.php?module=campaignDisplay&campaign_id={$dataParent.campaign_id}"><img src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t}&nbsp;{$dataParent.campaign_name}</a>
        &nbsp;

    <a href="index.php?module=operationDisplay&campaign_id={$dataParent.campaign_id}&operation_id={$dataParent.operation_id}&activeTab=tab-ambience">
                <img src="display/images/display-green.png" height="25">   {t}Retour à l'opération{/t} {$dataParent.operation_name}</a>
    {if $origin=="sequence"}
        <a href="index.php?module=sequenceDisplay&sequence_id={$dataParent.sequence_id}&activeTab=tab-ambience">
            <img src="display/images/display.png" height="25">
            {t}Retour à la séquence{/t}&nbsp;{$dataParent.sequence_number}
        </a>
    {/if}
</div>
<div class="row form-display">


    <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
        <input type="hidden" name="moduleBase" value="ambience{$origin}">
        <input type="hidden" name="action" value="Write">
        <input type="hidden" name="ambience_id" value="{$data.ambience_id}">
        <input type="hidden" name="operation_id" value="{$data.operation_id}">
        <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
        <input type="hidden" name="other_measures" id="metadataField" value="{$data.other_measures}">

        <input type="hidden" name="activeTab" value="tab-ambience">
        <div class="col-md-4 ">
            <div class="form-group">
                <label for="ambience_name"  class="control-label col-md-4">{t}Nom de l'ambiance :{/t}</label>
                <div class="col-md-8">
                    <input id="ambience_name" type="text" class="form-control" name="ambience_name" value="{$data.ambience_name}" autofocus>
                </div>
            </div>
            <div class="form-group">
                <label for="ambience_long"  class="control-label col-md-4">{t}Longitude :{/t}</label>
                <div class="col-md-8">
                    <input id="ambience_long" name="ambience_long" value="{$data.ambience_long}" class="form-control position">
                </div>
            </div>
            <div class="form-group">
                <label for="ambience_lat"  class="control-label col-md-4">{t}Latitude :{/t}</label>
                <div class="col-md-8">
                    <input id="ambience_lat" name="ambience_lat" value="{$data.ambience_lat}" class="form-control position">
                </div>
            </div>
            <div class="form-group">
                <label for="situation_id"  class="control-label col-md-4">{t}Situation :{/t}</label>
                <div class="col-md-8">
                    <select id="situation_id" name="situation_id" class="form-control">
                        <option value="" {if $data.situation_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                        {foreach $situations as $row}
                            <option value="{$row.situation_id}" {if $data.situation_id == $row.situation_id}selected{/if}>
                                {$row.situation_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="localisation_id"  class="control-label col-md-4">{t}Localisation :{/t}</label>
                <div class="col-md-8">
                    <select id="localisation_id" name="localisation_id" class="form-control">
                        <option value="" {if $data.localisation_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                        {foreach $localisations as $row}
                            <option value="{$row.localisation_id}" {if $data.localisation_id == $row.localisation_id}selected{/if}>
                                {$row.localisation_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="ambience_length"  class="control-label col-md-4">{t}Longueur (en m) :{/t}</label>
                <div class="col-md-8">
                    <input id="ambience_length" name="ambience_length" value="{$data.ambience_length}" class="form-control">
                </div>
            </div>
            <div class="form-group">
                <label for="ambience_width"  class="control-label col-md-4">{t}Largeur (en m) :{/t}</label>
                    <div class="col-md-8">
                    <input id="ambience_width" name="ambience_width" value="{$data.ambience_width}" class="form-control">
                </div>
            </div>
            <fieldset>
                <legend>{t}Lame d'eau{/t}</legend>
                <div class="form-group">
                    <label for="speed_id"  class="control-label col-md-4">{t}Classe de vitesse du courant (cm/s) :{/t}</label>
                    <div class="col-md-8">
                        <select id="speed_id" name="speed_id" class="form-control">
                        <option value="" {if $data.speed_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $speeds as $row}
                                <option value="{$row.speed_id}" {if $data.speed_id == $row.speed_id}selected{/if}>
                                    {$row.speed_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for=""  class="control-label col-md-4">{t}Vitesse du courant : moy / min / max (cm/s){/t}</label>
                    <div class="col-md-8">
                        <input id="current_speed" name="current_speed" value="{$data.current_speed}" class="form-control">
                        <input id=current_speed_min" name="current_speed_min" value="{$data.current_speed_min}" class="form-control" placeholder="{t}Valeur mini{/t}">
                        <input id="current_speed_max" name="current_speed_max" value="{$data.current_speed_max}" class="form-control"placeholder="{t}Valeur maxi{/t}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="water_height"  class="control-label col-md-4">{t}Hauteur d'eau : moy / min / max (cm){/t}</label>
                    <div class="col-md-8">
                        <input id="water_height" name="water_height" value="{$data.water_height}" class="form-control">
                        <input id=water_height_min" name="water_height_min" value="{$data.water_height_min}" class="form-control" placeholder="{t}Valeur mini{/t}">
                        <input id="water_height_max" name="water_height_max" value="{$data.water_height_max}" class="form-control"placeholder="{t}Valeur maxi{/t}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="flow_trend_id"  class="control-label col-md-4">{t}Régime hydrologique :{/t}</label>
                    <div class="col-md-8">
                        <select id="flow_trend_id" name="flow_trend_id" class="form-control">
                        <option value="" {if $data.flow_trend_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $flow_trends as $row}
                                <option value="{$row.flow_trend_id}" {if $data.flow_trend_id == $row.flow_trend_id}selected{/if}>
                                    {$row.flow_trend_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="turbidity_id"  class="control-label col-md-4">{t}Turbidité :{/t}</label>
                    <div class="col-md-8">
                        <select id="turbidity_id" name="turbidity_id" class="form-control">
                        <option value="" {if $data.turbidity_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $turbiditys as $row}
                                <option value="{$row.turbidity_id}" {if $data.turbidity_id == $row.turbidity_id}selected{/if}>
                                    {$row.turbidity_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
            </fieldset>
        </div>

        <div class="col-md-4">
            <fieldset>
                <legend>{t}Caractéristiques du milieu{/t}</legend>
                <div class="form-group">
                    <label for="facies_id"  class="control-label col-md-4">{t}Faciès :{/t}</label>
                    <div class="col-md-8">
                        <select id="facies_id" name="facies_id" class="form-control">
                        <option value="" {if $data.facies_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $faciess as $row}
                                <option value="{$row.facies_id}" {if $data.facies_id == $row.facies_id}selected{/if}>
                                    {$row.facies_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="vegetation_id"  class="control-label col-md-4">{t}Végétation :{/t}</label>
                    <div class="col-md-8">
                        <select id="vegetation_id" name="vegetation_id" class="form-control">
                        <option value="" {if $data.vegetation_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $vegetations as $row}
                                <option value="{$row.vegetation_id}" {if $data.vegetation_id == $row.vegetation_id}selected{/if}>
                                    {$row.vegetation_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="sinuosity_id"  class="control-label col-md-4">{t}Sinuosité :{/t}</label>
                    <div class="col-md-8">
                        <select id="sinuosity_id" name="sinuosity_id" class="form-control">
                        <option value="" {if $data.sinuosity_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $sinuositys as $row}
                                <option value="{$row.sinuosity_id}" {if $data.sinuosity_id == $row.sinuosity_id}selected{/if}>
                                    {$row.sinuosity_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="shady_id"  class="control-label col-md-4">{t}Ombrage :{/t}</label>
                    <div class="col-md-8">
                        <select id="shady_id" name="shady_id" class="form-control">
                        <option value="" {if $data.shaddy_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $shadys as $row}
                                <option value="{$row.shady_id}" {if $data.shady_id == $row.shady_id}selected{/if}>
                                    {$row.shady_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="dominant_granulometry_id"  class="control-label col-md-4">{t}Granulométrie principale :{/t}</label>
                    <div class="col-md-8">
                        <select id="dominant_granulometry_id" name="dominant_granulometry_id" class="form-control">
                        <option value="" {if $data.dominant_granulometry_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $granulometrys as $row}
                                <option value="{$row.granulometry_id}" {if $data.dominant_granulometry_id == $row.granulometry_id}selected{/if}>
                                    {$row.granulometry_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="secondary_granulometry_id"  class="control-label col-md-4">{t}Granulométrie secondaire :{/t}</label>
                    <div class="col-md-8">
                        <select id="secondary_granulometry_id" name="secondary_granulometry_id" class="form-control">
                        <option value="" {if $data.secondary_granulometry_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $granulometrys as $row}
                                <option value="{$row.granulometry_id}" {if $data.secondary_granulometry_id == $row.granulometry_id}selected{/if}>
                                    {$row.granulometry_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="clogging_id"  class="control-label col-md-4">{t}Colmatage :{/t}</label>
                    <div class="col-md-8">
                        <select id="clogging_id" name="clogging_id" class="form-control">
                        <option value="" {if $data.clogging_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $cloggings as $row}
                                <option value="{$row.clogging_id}" {if $data.clogging_id == $row.clogging_id}selected{/if}>
                                    {$row.clogging_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
            </fieldset>
            <fieldset>
                <legend>{t}Abondance des caches{/t}</legend>
                <div class="form-group">
                    <label for="herbarium_cache_abundance_id"  class="control-label col-md-4">{t}Herbiers :{/t}</label>
                    <div class="col-md-8">
                        <select id="herbarium_cache_abundance_id" name="herbarium_cache_abundance_id" class="form-control">
                        <option value="" {if $data.cache_abundance_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $cache_abundances as $row}
                                <option value="{$row.cache_abundance_id}" {if $data.herbarium_cache_abundance_id == $row.cache_abundance_id}selected{/if}>
                                    {$row.cache_abundance_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="branch_cache_abundance_id"  class="control-label col-md-4">{t}Branchages :{/t}</label>
                    <div class="col-md-8">
                        <select id="branch_cache_abundance_id" name="branch_cache_abundance_id" class="form-control">
                        <option value="" {if $data.branch_cache_abundance_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $cache_abundances as $row}
                                <option value="{$row.cache_abundance_id}" {if $data.branch_cache_abundance_id == $row.cache_abundance_id}selected{/if}>
                                    {$row.cache_abundance_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="vegetation_cache_abundance_id"  class="control-label col-md-4">{t}Végétation :{/t}</label>
                    <div class="col-md-8">
                        <select id="vegetation_cache_abundance_id" name="vegetation_cache_abundance_id" class="form-control">
                        <option value="" {if $data.vegetation_cache_abundance_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $cache_abundances as $row}
                                <option value="{$row.cache_abundance_id}" {if $data.vegetation_cache_abundance_id == $row.cache_abundance_id}selected{/if}>
                                    {$row.cache_abundance_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="subbank_cache_abundance_id"  class="control-label col-md-4">{t}Sous-berge :{/t}</label>
                    <div class="col-md-8">
                        <select id="subbank_cache_abundance_id" name="subbank_cache_abundance_id" class="form-control">
                        <option value="" {if $data.subbank_cache_abundance_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $cache_abundances as $row}
                                <option value="{$row.cache_abundance_id}" {if $data.subbank_cache_abundance_id == $row.cache_abundance_id}selected{/if}>
                                    {$row.cache_abundance_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="granulometry_cache_abundance_id"  class="control-label col-md-4">{t}Cailloux, blocs :{/t}</label>
                    <div class="col-md-8">
                        <select id="granulometry_cache_abundance_id" name="granulometry_cache_abundance_id" class="form-control">
                        <option value="" {if $data.granulometry_cache_abundance_id==""}selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $cache_abundances as $row}
                                <option value="{$row.cache_abundance_id}" {if $data.granulometry_cache_abundance_id == $row.cache_abundance_id}selected{/if}>
                                    {$row.cache_abundance_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
            </fieldset>
            <fieldset>
                <legend>{t}Mesures complémentaires{/t}</legend>
                <div class="form-group">
                    <div class="col-md-10 col-sm-offset-1">
                        <div id="metadata"></div>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="col-md-4">
                {include file="gestion/ambienceMap.tpl"}
        </div>

        <div class="col-md-12">
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.ambience_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </div>
    </form>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>