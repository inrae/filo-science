{include file="param/metadataFormJS.tpl"}
<script type="text/javascript">
    $(document).ready(function() {

        var metadataParse= $("#metadataField").val();
        if (metadataParse.length > 0) {
            metadataParse = metadataParse.replace(/&quot;/g,'"');
            metadataParse = JSON.parse(metadataParse);
        }
        renderForm(metadataParse);

        $('#metadataForm').submit(function(event) {
        	if ($("#action").val() == "Write") {
                if ($("#taxon_id").val() > 0) {
                    $('#metadata').alpaca().refreshValidationState(true);
                    if(!$('#metadata').alpaca().isValid(true)){
                        alert("{t}La définition des métadonnées n'est pas valide.{/t}");
                        event.preventDefault();
                    }
                } else {
                    event.preventDefault();
                }
        	}
        });
        $("#taxon-search").keyup(function() { 
            var name = $(this).val();
            if (name.length > 2) {
                var options = "";
                var url = "index.php";
                var data = { "module": "taxonSearchAjax",
                            "name":name,
                            "freshwater" : false,
                            "noFreshcode" : 1
                        };
                $.ajax( {
                    url: "index.php",
                    data: data
                })
                .done (function(data) {
                    var result = JSON.parse(data);
                    //options = '<option value="" selected></option>';			
                    for (var i = 0; i < result.length; i++) {
                        options += '<option value="' + result[i].taxon_id + '">'
                                + result[i].scientific_name;
                        if (result[i].common_name.length > 0) {
                            options += ' (' + result[i].common_name + ')';
                        }
                        options += '</option>';
                    }
                    ;
                    $("#taxon_id").html(options);
                });   
            }
        });
    });
</script>

<h2>{t}Création - Modification d'un modèle de mesures complémentaires sur un taxon{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <a href="index.php?module=measureTemplateList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>

        <form class="form-horizontal protoform" id="metadataForm" method="post" action="index.php" enctype="multipart/form-data">
            <input type="hidden" name="moduleBase" value="measureTemplate">
            <input type="hidden" id="action" name="action" value="Write">
            <input type="hidden" name="measure_template_id" value="{$data.measure_template_id}">
            <input type="hidden" name="measure_template_schema" id="metadataField" value="{$data.measure_template_schema}">
            <div class="form-group">
                <label for="metadataName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du modèle :{/t}</label>
                <div class="col-md-8">
                <input id="metadataName" type="text" class="form-control" name="measure_template_name" value="{$data.measure_template_name}" required autofocus>
                </div>
            </div>
            <fieldset>
                <legend>{t}Taxon concerné{/t}</legend>
                <div class="form-group">
                    <label for="taxon-search"  class="control-label col-md-4"> {t}Nom à rechercher :{/t}</label>
                    <div class="col-md-8">
                        <input id="taxon-search" type="text" class="form-control" value="">
                    </div>
            </div>
            <div class="form-group">
                    <label for="taxon_id"  class="control-label col-md-4"> <span class="red">*</span> {t}Taxon correspondant :{/t}</label>
                <div class="col-md-8">
                    <select id="taxon_id" class="form-control" name="taxon_id">
                        {if $data.taxon_id > 0}
                            <option value="{$data.taxon_id}" selected>
                                {$data.scientific_name}
                                {if strlen($data.common_name) > 0}
                                    ({$data.common_name})
                                {/if}
                            </option>
                        {/if}
                    </select>
                </div>
            </div>
            </fieldset>
            
            <fieldset>
                <legend>{t}Mesures complémentaires{/t}</legend>
                <div id="metadata"></div>
            </fieldset>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.measure_template_id > 0 }
                 <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
