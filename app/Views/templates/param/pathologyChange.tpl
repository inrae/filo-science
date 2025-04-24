<h2>{t}Création - Modification d'une pathologie{/t}</h2>
<a href="pathologyList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="pathology">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="pathology_id" value="{$data.pathology_id}">
            <div class="form-group">
                <label for="paramName"  class="control-label col-md-4"><span class="red">*</span> {t}Libellé :{/t}</label>
                <div class="col-md-8">
                    <input id="paramName" type="text" class="form-control" name="pathology_name" value="{$data.pathology_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="pathology_code"  class="control-label col-md-4"> {t}Code :{/t}</label>
                <div class="col-md-8">
                    <input id="pathology_code" type="text" class="form-control" name="pathology_code" value="{$data.pathology_code}" >
                </div>
            </div>
            <div class="form-group">
                <label for="pathology_description" class="control-label col-md-4">{t}Description :{/t}</label>
                <div class="col-md-8">
                    <textarea class="md-textarea form-control" id="pathology_code" name="pathology_description">{$data.pathology_description}</textarea>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.pathology_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        {$csrf}</form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>