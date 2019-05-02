<script>
$(document).ready(function() {
    /* Taxon search */
    $("#taxon-search").keyup(function() { 
        var name = $(this).val();
        if (nom.length > 2) {
            var options = "";
            var url = "index.php";
            $.getJSON(url, {
                "module" : "taxonSearchAjax",
                "name" : name
            }, function(data) {
                //options = '<option value="" selected></option>';			
                for (var i = 0; i < data.length; i++) {
                    options += '<option value="' + data[i].taxon_id + '">'
                            + data[i].scientific_name;
                    if (data[i].common_name.length > 0) {
                        options += ' (' + data[i].common_name + ')';
                    }
                    options += '</option>';
                }
                ;
                $("#taxon_id").html(options);
            });
            $("#taxon_id").change();
        }
    });
    $("#taxon_id").change(function () { 
        /* Get the name of the taxon */
        var taxonId = $("#taxon_id").val();
        if (taxonId.length>0) {
            $.ajax( {
                url: "index.php",
                data: { "module": "taxonGetName", "taxon_id":taxonId}
            })
            .done (function(value) { 
                if (value) {
                    var name = JSON.parse(value);
                    $("#taxon_name").val(name.scientific_name);
                }
            });
        }
    });



});
</script>

<h2>{t}Opération{/t} {$sequence.operation_name}, {t}séquence{/t}&nbsp;{$sequence.sequence_number}</h2>
<div class="row">
    <div class="col-md-12">
        <a href="index.php?module=campaignDisplay&campaign_id={$sequence.campaign_id}"><img src="display/images/display-red.png" height="25">
            {t}Retour à la campagne{/t} {$sequence.campaign_name}
        </a>
        &nbsp;
        <a href="index.php?module=operationDisplay&campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}">
            <img src="display/images/display-green.png" height="25">{t}Retour à l'opération{/t} {$data.operation_name}
        </a>
        &nbsp;
        <a href="index.php?module=sequenceDisplay&campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}&sequence_id={$data.sequence_id}&activeTab=tab-sequence">
            <img src="display/images/display.png" height="25">{t}Retour à la séquence{/t} {$data.sequence_number}
        </a>
    </div>
    <div class="col-md-12">
        <a href="index.php?module=sampleChange&sequence_id={$sequence.sequence_id}&operation_id={$sequence.operation_id}&sample_id=0">
            <img src="display/images/new.gif" height="25">{t}Nouveau lot{/t}
        </a>

    </div>

</div>
<div class="row col-md-12">
    <div class="row col-md-4">
        <fieldset>
                <legend>{t}Détail du lot{/t}</legend>
                <form id="lotform" class="form-horizontal protoform" method="post" action="index.php">
                        <input type="hidden" name="moduleBase" value="sample">
                        <input type="hidden" name="action" value="Write">
                        <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
                        <input type="hidden" name="sample_id" value="{$data.sample_id}">
                        <div class="form-group">
                                <label for="taxon-search"  class="control-label col-md-4"> {t}Code ou nom à rechercher :{/t}</label>
                                <div class="col-md-8">
                                    <input id="taxon-search" type="text" class="form-control" name="taxon-search" value="">
                                </div>
                        </div>
                        <div class="form-group">
                                <label for="taxon_id"  class="control-label col-md-4"> {t}Taxon correspondant :{/t}</label>
                            <select id="taxon_id" class="form-control">

                            </select>
                        </div>
                        <div class="form-group">
                            <label for="taxon_name"  class="control-label col-md-4"> {t}Nom du taxon :{/t}<span class="red">*</span></label>
                            <div class="col-md-8">
                                <input id="taxon_name" type="text" class="form-control" name="taxon_name" value="{$data.taxon_name}" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="total_number"  class="control-label col-md-4"> {t}Nombre total :{/t}</label>
                            <div class="col-md-8">
                                <input id="total_number" type="text" class="form-control nombre" name="sl" value="{$data.total_number}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="total_measured"  class="control-label col-md-4"> {t}Nombre mesurés :{/t}</label>
                            <div class="col-md-8">
                                <input id="total_measured" type="text" class="form-control nombre" name="total_measured" value="{$data.total_measured}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="total_weight"  class="control-label col-md-4"> {t}Poids total (g) :{/t}</label>
                            <div class="col-md-8">
                                <input id="total_weight" type="text" class="form-control nombre" name="total_weight" value="{$data.total_weight}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="sample_size_min"  class="control-label col-md-4"> {t}Longueur minimale mesurée (cm) :{/t}</label>
                            <div class="col-md-8">
                                <input id="sample_size_min" type="text" class="form-control nombre" name="sample_size_min" value="{$data.sample_size_min}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="sample_size_max"  class="control-label col-md-4"> {t}Longueur maximale mesurée (cm) :{/t}</label>
                            <div class="col-md-8">
                                <input id="sample_size_max" type="text" class="form-control nombre" name="sample_size_max" value="{$data.sample_size_max}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="sample_comment"  class="control-label col-md-4"> {t}Commentaire :{/t}</label>
                            <div class="col-md-8">
                                <textarea id="sample_comment" type="text" class="form-control" name="sample_comment">{$data.sample_comment}</textarea>
                            </div>
                        </div>

                         <div class="form-group center">
                            <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                            {if $data.sample_id > 0 }
                                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                            {/if}
                        </div>
                </form>
        </fieldset>
        {if $data.sample_id > 0}
            <fieldset>
                <legend>{t}Poisson mesuré{/t}</legend>
                    <form id="individualForm" class="form-horizontal protoform" method="post" action="index.php">

                    </form>
            </fieldset>
        {/if}
    </div>
    <div class="col-md-8">
        <fieldset>
            <legend>{t}Poissons mesurés{/t}</legend>
            <table class="table table-bordered table-hover datatable-nopaging" data-order='[[0,"desc"]]'>
                <thead>
                    <th>{t}Id{/t}</th>
                    <th>{t}standard{/t}</th>
                    <th>{t}Fourche{/t}</th>
                    <th>{t}Totale{/t}</th>
                    <th>{t}Disque{/t}</th>
                    <th>{t}Autre{/t}</th>
                    <th>{t}Poids{/t}</th>
                </thead>
                <tbody>

                </tbody>
            </table>
        </fieldset>
    </div>
</div>
