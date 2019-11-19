<h2>{t}Modification d'un modèle d'import{/t}</h2>
<div class="row">
    <a href="index.php?module=importTypeList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
</div>
<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal protoform" id="importForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="importType">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="import_type_id" value="{$data.import_type_id}">
            <div class="form-group">
                <label for="import_type_name" class="control-label col-md-4">
                    <span class="red">*</span> {t}Nom du type d'import :{/t}
                </label>
                <div class="col-md-8">
                    <input class="form-control" id="import_type_name" name="import_type_name" value="{$data.import_type_name}" required autofocus>
                </div>
            </div>
            <div class="form-group">
                <label for="tablename" class="control-label col-md-4">
                    <span class="red">*</span> {t}Nom de la table cible :{/t}
                </label>
                <div class="col-md-8">
                    <input class="form-control" id="tablename" name="tablename" value="{$data.tablename}" required >
                </div>
            </div>
            <div class="form-group">
                    <label for="column_list" class="control-label col-md-4">
                        <span class="red">*</span> {t}Liste des colonnes cibles, séparées par une virgule :{/t}
                    </label>
                    <div class="col-md-8">
                        <input class="form-control" id="column_list" name="column_list" value="{$data.column_list}" required >
                    </div>
                </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.import_type_id > 0 }
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>