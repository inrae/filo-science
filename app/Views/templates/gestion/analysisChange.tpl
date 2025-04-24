<script type="text/javascript" src="display/javascript/formbuilder.js"></script>
<script>
$(document).ready(function() {
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
    var schema = "{$analysis_template_schema}";
    if (schema.length > 0) {
        schema = schema.replace(/&quot;/g,'"');
        showForm(JSON.parse(schema),dataParse);
    }
});
</script>
<div class="row">
    <a href="campaignDisplay?campaign_id={$dataParent.campaign_id}">
        <img src="display/images/display-red.png" height="25">
        {t}Retour à la campagne{/t}&nbsp;{$sequence.campaign_name}
    </a>
    &nbsp;
    <a href="operationDisplay?campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}&activeTab=tab-sequence">
            <img src="display/images/display-green.png" height="25">
            {t}Retour à l'opération{/t} {$sequence.operation_name}
    </a>
    &nbsp;
    <a href="sequenceDisplay?sequence_id={$sequence.sequence_id}&activeTab=tab-analysis">
        <img src="display/images/display.png" height="25">
        {t}Retour à la séquence{/t}&nbsp;{$sequence.sequence_number}
    </a>
</div>

<div class="row">
    <form class="form-horizontal  col-md-6" id="paramForm" method="post" action="analysisWrite">
        <input type="hidden" name="moduleBase" value="analysis">
        <input type="hidden" name="analysis_id" value="{$data.analysis_id}">
        <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
        <input type="hidden" name="activeTab" value="tab-analysis">
        <input type="hidden" name="other_analysis" id="metadataField" value="{$data.other_analysis}">
        <div class="form-group">
            <label for="analysis_date"  class="control-label col-md-4">{t}Date-Heure de l'analyse :{/t}</label>
            <div class="col-md-8">
                <input id="analysis_date" type="text" class="form-control datetimepicker" name="analysis_date" value="{$data.analysis_date}" autofocus>
            </div>
        </div>
        <div class="form-group">
            <label for="ph"  class="control-label col-md-4">{t}pH :{/t}</label>
            <div class="col-md-8">
                <input id="ph" type="text" class="form-control taux" name="ph" value="{$data.ph}" >
            </div>
        </div>
        <div class="form-group">
            <label for="temperature"  class="control-label col-md-4">{t}Température (°C) :{/t}</label>
            <div class="col-md-8">
                <input id="temperature" type="text" class="form-control taux" name="temperature" value="{$data.temperature}" >
            </div>
        </div>
        <div class="form-group">
            <label for="o2_pc"  class="control-label col-md-4">{t}% de saturation O2 :{/t}</label>
            <div class="col-md-8">
                <input id="o2_pc" type="text" class="form-control taux" name="o2_pc" value="{$data.o2_pc}" >
            </div>
        </div>
        <div class="form-group">
            <label for="o2_mg"  class="control-label col-md-4">{t}O2, en mg/l :{/t}</label>
            <div class="col-md-8">
                <input id="o2_mg" type="text" class="form-control taux" name="o2_mg" value="{$data.o2_mg}" >
            </div>
        </div>
        <div class="form-group">
            <label for="salinity"  class="control-label col-md-4">{t}Salinité :{/t}</label>
            <div class="col-md-8">
                <input id="salinity" type="text" class="form-control taux" name="salinity" value="{$data.salinity}" >
            </div>
        </div>
        <div class="form-group">
            <label for="conductivity"  class="control-label col-md-4">{t}Conductivité, en µS/cm :{/t}</label>
            <div class="col-md-8">
                <input id="conductivity" type="text" class="form-control taux" name="conductivity" value="{$data.conductivity}" >
            </div>
        </div>
        <div class="form-group">
            <label for="secchi"  class="control-label col-md-4">{t}Secchi, en mètre :{/t}</label>
            <div class="col-md-8">
                <input id="secchi" type="text" class="form-control taux" name="secchi" value="{$data.secchi}" >
            </div>
        </div>
        <fieldset>
            <legend>{t}Analyses complémentaires{/t}</legend>
            <div class="form-group">
                <div class="col-md-10 col-sm-offset-1">
                    <div id="metadata"></div>
                </div>
            </div>
        </fieldset>
        <div class="col-md-12">
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.analysis_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </div>
    {$csrf}</form>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>