<h2>{t}Création - Modification d'un operateur{/t}</h2>
<a href="index.php?module=operatorList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="operator">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="operator_id" value="{$data.operator_id}">
            <div class="form-group">
                <label for="firstname"  class="control-label col-md-4"><span class="red">*</span> {t}Prénom :{/t}</label>
                <div class="col-md-8">
                    <input id="firstname" type="text" class="form-control" name="firstname" value="{$data.firstname}" autofocus>
                </div>
            </div>
            <div class="form-group">
                <label for="name"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
                <div class="col-md-8">
                    <input id="name" type="text" class="form-control" name="name" value="{$data.name}"  required>
                </div>
            </div>
            <div class="form-group">
                <label for="is_active" class="col-md-4 control-label">{t}Actif ?{/t}</label>
                <span id="is_active">
                    <label class="radio-inline">
                        <input type="radio" name="is_active" value="1" {if $data.is_active == 1}checked{/if}>{t}oui{/t}
                    </label>
                    <label class="radio-inline">
                        <input type="radio" name="is_active" value="0" {if $data.is_active == 0}checked{/if}>{t}non{/t}
                    </label>
                </span>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.operator_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>