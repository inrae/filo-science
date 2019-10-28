{include file="import/modelPatternJS.tpl"}
<script type="text/javascript">
    $(document).ready(function () {

        var pattern = $("#pattern").val();
        console.log(pattern);
        if (pattern.length > 0) {
            pattern = pattern.replace(/&quot;/g, '"');
            pattern = JSON.parse(pattern);
        } else {}
        
        patternForm(pattern);

        $('#exportModelForm').submit(function (event) {
            if ($("#action").val() == "Write") {
                $('#alpacaPattern').alpaca().refreshValidationState(true);
                if (!$('#alpacaPattern').alpaca().isValid(true)) {
                    alert("{t}La définition du modèle n'est pas valide.{/t}");
                    event.preventDefault();
                }
            }
        });
    });
</script>
<h2>{t}Création - Modification d'un modèle d'export de données{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <a href="index.php?module=exportModelList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>

        <form class="form-horizontal protoform" id="exportModelForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="exportModel">
            <input type="hidden" id="action" name="action" value="Write">
            <input type="hidden" name="export_model_id" value="{$data.export_model_id}">
            <input type="hidden" name="pattern" id="pattern" value="{$data.pattern}">
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
            </div>
            <div class="form-group">
                <label for="export_model_name"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du modèle :{/t}</label>
                <div class="col-md-8">
                <input id="export_model_name" type="text" class="form-control" name="export_model_name" value="{$data.export_model_name}" required autofocus>
                </div>
            </div>
            <div id="alpacaPattern"></div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.export_model_id > 0 }
                 <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
