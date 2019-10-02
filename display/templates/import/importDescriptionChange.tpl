<h2>{t}Modification d'un modèle d'import{/t}</h2>
<div class="row">
    <a href="index.php?module=importDescriptionList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    {if $data.import_description_id > 0}
    &nbsp;
    <img src="display/images/display.png" height="25">
    <a href="index.php?module=importDescriptionDisplay&import_description_id={$data.import_description_id}">
        {t}Retour au détail{/t}
    </a>
    {/if}
</div>
<div class="row">
        <div class="col-md-6">
            <form class="form-horizontal protoform" id="importForm" method="post" action="index.php">
                <input type="hidden" name="moduleBase" value="importDescription">
                <input type="hidden" name="action" value="Write">
                <input type="hidden" name="import_description_id" value="{$data.import_description_id}">
                <div class="form-group">
                    <label for="import_type_id" class="control-label col-md-4">
                        <span class="red">*</span> {t}Type d'import :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="import_type_id" name="import_type_id" class="form-control" autofocus>
                            {foreach $importTypes as $importType}
                                <option value="{$importType.import_type_id}" {if $data.import_type_id == $importType.import_type_id}selected{/if}>
                                    {$importType.import_type_name}
                                </option>
                            {/foreach}
                    </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="csv_type_id" class="control-label col-md-4">
                        <span class="red">*</span> {t}Type de fichier CSV :{/t}
                    </label>
                    <div class="col-md-8">
                       <select id="csv_type_id" name="csv_type_id" class="form-control">
                            {foreach $csvTypes as $csvType}
                                <option value="{$csvType.csv_type_id}" {if $data.csv_type_id == $csvType.csv_type_id}selected{/if}>
                                    {$csvType.csv_type_name}
                                </option>
                            {/foreach}
                        </select> 
                    </div>
                </div>
                <div class="form-group">
                    <label for="import_description_name"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du modèle :{/t}</label>
                    <div class="col-md-8">
                        <input id="import_description_name" type="text" class="form-control" name="import_description_name" value="{$data.import_description_name}" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="separator" class="control-label col-md-4">
                        <span class="red">*</span> {t}Séparateur de champs :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="separator" name="separator" class="form-control">
                            <option value=";" {if $data.separator == ";"}selected{/if}>
                                {t}point-virgule{/t} 
                            </option>
                            <option value="," {if $data.separator == ","}selected{/if}>
                                {t}virgule{/t} 
                            </option>
                            <option value="tab" {if $data.separator == "tab"}selected{/if}>
                                {t}tabulation{/t} 
                            </option>
                            <option value="space" {if $data.separator == "space"}selected{/if}>
                                {t}espace{/t} 
                            </option>   
                        </select>
                    </div>
                </div>

                <div class="form-group center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        {if $data.import_description_id > 0 }
                            <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        {/if}
                    </div>
                </form>
            </div>
        </div>
        <span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>           