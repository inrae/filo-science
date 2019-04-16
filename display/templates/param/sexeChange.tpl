<h2>{t}Création - Modification d'un sexe{/t}</h2>
<a href="index.php?module=sexeList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="sexe">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="sexe_id" value="{$data.sexe_id}">
            <div class="form-group">
                <label for="paramName"  class="control-label col-md-4"><span class="red">*</span> {t}Libellé :{/t}</label>
                <div class="col-md-8">
                    <input id="paramName" type="text" class="form-control" name="sexe_name" value="{$data.sexe_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="sexe_code"  class="control-label col-md-4"><span class="red">*</span> {t}Code :{/t}</label>
                <div class="col-md-8">
                    <input id="sexe_code" type="text" class="form-control" name="sexe_code" value="{$data.sexe_code}"  required>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.sexe_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>