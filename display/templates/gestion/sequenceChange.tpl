<h2>{t}Création - Modification d'une séquence{/t}</h2>
<a href="index.php?module=campaignDisplay&campaign_id={$data.campaign_id}"><img src="display/images/list.png" height="25">{t}Retour à la campagne{/t}</a>
<a href="index.php?module=operationDisplay&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}"><img src="display/images/new.png" height="25">{t}Retour à l'opération{/t}</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="sequence">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
            <input type="hidden" name="operation_id" value="{$data.operation_id}">
            <div class="form-group">
                <label for="sequence_number"  class="control-label col-md-4"> {t}N° d'ordre de la séquence :{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                    <input id="sequence_number" type="text" class="form-control nombre" name="sequence_number" value="{$data.sequence_number}" required>
                </div>
            </div>
            <div class="form-group">
                <label for="date_start"  class="control-label col-md-4"> {t}Date-heure de début :{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                
                    <input id="date_start" name="date_start" class="form-control datetimepicker" value="{$data.date_start}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="date_end"  class="control-label col-md-4"> {t}Date-heure de fin :{/t}</label>
                <div class="col-md-8">
                
                    <input id="date_end" name="date_end" class="form-control datetimepicker" value="{$data.date_end}" >
                </div>
            </div>
            <div class="form-group">
                <label for="fishing_duration"  class="control-label col-md-4"> {t}Durée de pêche (mn) :{/t}</label>
                <div class="col-md-8">
                    <input id="fishing_duration" type="text" class="form-control nombre" name="fishing_duration" value="{$data.fishing_duration}">
                </div>
            </div>
          
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.sequence_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>