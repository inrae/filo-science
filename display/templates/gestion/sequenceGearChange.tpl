<h2>{t}Rattachement d'un engin à une séquence{/t}</h2>
<a href="index.php?module=campaignDisplay&campaign_id={$sequence.campaign_id}"><img
    src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t}&nbsp;{$sequence.campaign_name}</a>
&nbsp;
<a
href="index.php?module=operationDisplay&campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}&activeTab=tab-sequence">
<img src="display/images/display-green.png" height="25"> {t}Retour à l'opération{/t}&nbsp;{$sequence.operation_name}</a>

<a href="index.php?module=sequenceDisplay&sequence_id={$sequence.sequence_id}&activeTab=tab-gear">
    <img src="display/images/display.png" height="25">{t}Retour à la séquence{/t}
</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="sequenceGear">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="sequence_gear_id" value="{$data.sequence_gear_id}">
            <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
            <div class="form-group">
                <label for="gear_nb"  class="control-label col-md-4"> {t}Nombre d'engins :{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                    <input id="gear_nb" type="text" class="form-control nombre" name="gear_nb" value="{$data.gear_nb}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="voltage"  class="control-label col-md-4"> {t}Voltage utilisé :{/t}</label>
                <div class="col-md-8">
                    <input id="voltage" type="text" class="form-control taux" name="voltage" value="{$data.voltage}">
                </div>
            </div>
             <div class="form-group">
                <label for="amperage"  class="control-label col-md-4"> {t}Ampérage utilisé :{/t}</label>
                <div class="col-md-8">
                    <input id="amperage" type="text" class="form-control taux" name="amperage" value="{$data.amperage}">
                </div>
            </div>
            <div class="form-group">
                <label for="depth"  class="control-label col-md-4"> {t}Profondeur de l'engin, en mètre :{/t}</label>
                <div class="col-md-8">
                    <input id="depth" type="text" class="form-control taux" name="depth" value="{$data.depth}">
                </div>
            </div>
           
            <div class="form-group">
                <label for="station_id"  class="control-label col-md-4">{t}Modèle d'engin utilisé :{/t}<span class="red">*</span></label>
                <div class="col-md-8">
                    <select id="gear_id" name="gear_id" class="form-control">
                    {foreach $gears as $row}
                        <option value="{$row.gear_id}" {if $row.gear_id == $data.gear_id}selected{/if}>
                        {$row.gear_name}
                        </option>
                    {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="gear_method_id"  class="control-label col-md-4"> {t}Méthode d'utilisation :{/t}</label>
                <div class="col-md-8">
                    <select id="gear_method_id" name="gear_method_id" class="form-control">
                        <option value ="" {if $row.gear_method_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
                        {foreach $gear_methods as $row}
                            <option value="{$row.gear_method_id}" {if $row.gear_method_id == $data.gear_method_id}selected{/if}>
                            {$row.gear_method_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="electric_current_type_id"  class="control-label col-md-4"> {t}Type de courant électrique :{/t}</label>
                <div class="col-md-8">
                    <select id="electric_current_type_id" name="electric_current_type_id" class="form-control">
                        <option value ="" {if $row.electric_current_type_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
                        {foreach $electric_current_types as $row}
                            <option value="{$row.electric_current_type_id}" {if $row.electric_current_type_id == $data.electric_current_type_id}selected{/if}>
                            {$row.electric_current_type_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>


            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.sequence_gear_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>