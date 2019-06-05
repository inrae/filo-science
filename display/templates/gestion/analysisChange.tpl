<div class="row">
    <a href="index.php?module=campaignDisplay&campaign_id={$dataParent.campaign_id}">
        <img src="display/images/display-red.png" height="25">
        {t}Retour à la campagne{/t}&nbsp;{$sequence.campaign_name}
    </a>
    &nbsp;
    <a href="index.php?module=operationDisplay&campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}&activeTab=tab-sequence">
            <img src="display/images/display-green.png" height="25">
            {t}Retour à l'opération{/t} {$sequence.operation_name}
    </a>
    &nbsp;
    <a href="index.php?module=sequenceDisplay&sequence_id={$sequence.sequence_id}&activeTab=tab-analysis">
        <img src="display/images/display.png" height="25">
        {t}Retour à la séquence{/t}&nbsp;{$sequence.sequence_number}
    </a>
</div>

<div class="row">
    <form class="form-horizontal protoform col-md-6" id="paramForm" method="post" action="index.php">
        <input type="hidden" name="moduleBase" value="analysis">
        <input type="hidden" name="action" value="Write">
        <input type="hidden" name="analysis_id" value="{$data.analysis_id}">
        <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
        <input type="hidden" name="activeTab" value="tab-analysis">
       
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

        <div class="col-md-12">
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.analysis_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </div>
    </form>  
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>