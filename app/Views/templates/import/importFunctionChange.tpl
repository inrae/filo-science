<script>
    $(document).ready(function() { 
        $("#column_number").change(function () { 
            $("#column_result").val($(this).val());
        });
        $("#function_type_id").change(function() { 
            getDescription();
        });
        function getDescription() { 
            var function_type_id = $("#function_type_id").val();
            $.ajax({
                url: "functionTypeGetDescription",
                data: { "function_type_id": function_type_id }
            })
            .done(function (value) {
                var val = JSON.parse(value);
                $("#description").html(val.description);
            });
        }
        getDescription();
    });
</script>

<h2>{t}Modification d'une fonction à exécuter lors de l'import{/t}</h2>
<div class="row">
    <a href="importDescriptionList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    &nbsp;
    <img src="display/images/display.png" height="25">
    <a href="importDescriptionDisplay?import_description_id={$data.import_description_id}">
        {t}Retour au détail{/t}
    </a>
</div>
<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal " id="importFunctionForm" method="post" action="importFunctionWrite">
            <input type="hidden" name="moduleBase" value="importFunction">
            <input type="hidden" name="import_description_id" value="{$data.import_description_id}">
            <input type="hidden" name="import_function_id" value="{$data.import_function_id}">
            <div class="form-group">
                <label for="function_type_id" class="control-label col-md-4">
                    <span class="red">*</span> {t}Fonction à exécuter :{/t}
                </label>
                <div class="col-md-8">
                    <select id="function_type_id" name="function_type_id" class="form-control" autofocus>
                        {foreach $functions as $function}
                            <option value="{$function.function_type_id}" {if $data.function_type_id==$function.function_type_id}selected{/if}>
                                {$function.function_name} 
                            </option> 
                        {/foreach} 
                    </select>
                    <br>
                    <textarea class="form-control textareaDisplay" disabled id="description" rows="4"></textarea>        
                </div> 
            </div>
            <div class="form-group">
                <label for="column_number" class="control-label col-md-4">
                        <span class="red">*</span> {t}N° de colonne à traiter :{/t}
                </label>
                <div class="col-md-8">
                    <input type="number" class="form-control" id="column_number" name="column_number" value="{$data.column_number}" required>
                </div>               
            </div>
            <div class="form-group">
                <label for="column_result" class="control-label col-md-4">
                        <span class="red">*</span> {t}N° de colonne récupérant le résultat (0 pour une fonction de contrôle sans transformation de données) :{/t}
                </label>
                <div class="col-md-8">
                    <input type="number" class="form-control" id="column_result" name="column_result" value="{$data.column_result}">
                </div>               
            </div>
            <div class="form-group">
                <label for="execution_order" class="control-label col-md-4">
                        <span class="red">*</span> {t}Ordre d'exécution de la fonction :{/t}
                </label>
                <div class="col-md-8">
                    <input type="number" class="form-control" id="execution_order" name="execution_order" value="{$data.execution_order}" required>
                </div>               
            </div>
            <div class="form-group">
                <label for="arguments" class="control-label col-md-4">
                        {t}Argument complémentaire :{/t}
                </label>
                <div class="col-md-8">
                    <input type="text" class="form-control" id="arguments" name="arguments" value="{$data.arguments}">
                </div>               
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.import_function_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        {$csrf}</form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>