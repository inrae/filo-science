<h2>{t}Modification de la description d'une colonne du fichier{/t}</h2>
<div class="row">
    <a href="importDescriptionList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    &nbsp;
    <img src="display/images/display.png" height="25">
    <a href="importDescriptionDisplay&import_description_id={$data.import_description_id}">
        {t}Retour au détail{/t}
    </a>
</div>
<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal protoform" id="importColumnForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="importColumn">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="import_description_id" value="{$data.import_description_id}">
            <input type="hidden" name="import_column_id" value="{$data.import_column_id}">
            <div class="form-group">
                <label for="column_order" class="control-label col-md-4">
                    <span class="red">*</span> {t}N° de la colonne (à partir de 1) :{/t}
                </label>
                <div class="col-md-8">
                    <input type="number" class="form-control" name="column_order" id="column_order" value="{$data.column_order}" required autofocus autocomplete="false">
                </div>
            </div>
            <div class="form-group">
                <label for="function_type_id" class="control-label col-md-4">
                    <span class="red">*</span> {t}Champ de la base de données recevant l'information :{/t}
                </label>
                <div class="col-md-8">
                    <select id="table_column_name" name="table_column_name" class="form-control">
                        {foreach $columns as $column}
                            <option value="{$column}" {if $data.table_column_name==$column}selected{/if}>
                                {$column}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="isErCheck" class="control-label col-md-4">
                    {t}La colonne sert-elle d'identifiant pour les tables de type Entité-Relation ?{/t}
                </label>
                <div class="col-md-8">
                    <div class="btn-group btn-toggle" data-toggle="buttons">
                        <label class="radio-inline">
                            <input type="radio" id="isEr1" name="is_er" value="1"  {if $data.is_er ==1}checked{/if}>oui
                        </label>
                        <label class="radio-inline">
                            <input type="radio" id="isEr0" name="is_er" value="0"  {if $data.is_er ==0}checked{/if}>non
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                    <label for="isValueCheck" class="control-label col-md-4">
                        {t}La colonne contient-elle la donnée pour les tables de type Entité-Relation ?{/t}
                    </label>
                    <div class="col-md-8">
                    <div class="btn-group btn-toggle" data-toggle="buttons">
                        <label class="radio-inline">
                            <input type="radio" id="isValue1" name="is_value" value="1"  {if $data.is_value ==1}checked{/if}>oui
                        </label>
                        <label class="radio-inline">
                            <input type="radio" id="isValue0" name="is_value" value="0"  {if $data.is_value ==0}checked{/if}>non
                        </label>
                    </div>
                </div>
                </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.import_column_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        {$csrf}</form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>