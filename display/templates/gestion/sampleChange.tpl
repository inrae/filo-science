<script>
$(document).ready(function() {
    var freshwater = {$sequence.freshwater};
    /* Taxon search */
    $("#taxon-search").keyup(function() { 
        var name = $(this).val();
        if (name.length > 2) {
            var options = "";
            var url = "index.php";
            var data = { "module": "taxonSearchAjax",
                        "name":name,
                        "freshwater" : freshwater
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
                $("#taxon_id").change();
            });   
        }
    });
    $("#taxon_id").change(function () { 
        /* Get the name of the taxon */
        var taxonId = $("#taxon_id").val();
        if (taxonId === null) {
            taxonId = 0;
        }
        if (taxonId > 0) {
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

    /* hide fields measures if necessary */
    var mdo = "{$sequence.measure_default_only}";
    var md = "{$sequence.measure_default}";
    if (mdo == "1") {
        var lengths = ["sl", "fl", "tl", "wd", "ot"];
        for (var i = 0; i < 5; i++) {
            if (md != lengths[i]) {
                $("#div-"+lengths[i]).hide();
            }
        }
    }

    /* Generate the change trigger for individual */
    $(".fish").change(function () { 
        $("#individualChange").val(1);
    });

    /* Delete an individual */
    $("#delete-individual").on('keyup click', function () { 
        var lib = "{t}Confirmez-vous la suppression ?{/t}" ;
        if (confirm(lib) == true) {
			$(this.form).find("input[name='action']").val("DeleteIndividual");
			$(this.form).submit();
		} else {
			return false;
		}
    });

});
</script>

<div class="row">
    <div class="col-md-12">
        <a href="index.php?module=campaignDisplay&campaign_id={$sequence.campaign_id}"><img src="display/images/display-red.png" height="25">
            {t}Retour à la campagne{/t} {$sequence.campaign_name}
        </a>
        &nbsp;
        <a href="index.php?module=operationDisplay&campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}&activeTab=tab-sequence">
            <img src="display/images/display-green.png" height="25">{t}Retour à l'opération{/t} {$sequence.operation_name}
        </a>
        &nbsp;
        <a href="index.php?module=sequenceDisplay&campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}&sequence_id={$sequence.sequence_id}&activeTab=tab-sample">
            <img src="display/images/display.png" height="25">{t}Retour à la séquence{/t} {$sequence.sequence_number}
        </a>
    </div>
    <div class="col-md-12">
        <a href="index.php?module=sampleChange&sequence_id={$sequence.sequence_id}&operation_id={$sequence.operation_id}&sample_id=0">
            <img src="display/images/new.png" height="25">{t}Nouveau lot{/t}
        </a>
        &nbsp;
        <a href="index.php?module=sampleChange&sequence_id={$sequence.sequence_id}&operation_id={$sequence.operation_id}&sample_id={$data.sample_id}&individual_id=0">
            <img src="display/images/fish.png" height="25">{t}Nouvelle capture{/t}
        </a>

    </div>

</div>
<div class="row col-md-12">
    <form id="lotform" method="post" action="index.php">
        <div class="col-md-6 form-horizontal"> 
            <fieldset>
                <legend>{t}Détail du lot{/t}</legend>            
                <input type="hidden" name="moduleBase" value="sample">
                <input type="hidden" name="action" value="Write">
                <input type="hidden" name="sequence_id" value="{$sequence.sequence_id}">
                <input type="hidden" name="sample_id" value="{$data.sample_id}">
                <div class="form-group">
                        <label for="taxon-search"  class="control-label col-md-4"> {t}Code ou nom à rechercher :{/t}</label>
                        <div class="col-md-8">
                            <input id="taxon-search" type="text" class="form-control" name="taxon-search" value="">
                        </div>
                </div>
                <div class="form-group">
                        <label for="taxon_id"  class="control-label col-md-4"> {t}Taxon correspondant :{/t}</label>
                    <div class="col-md-8">
                        <select id="taxon_id" class="form-control" name="taxon_id">
                            {if $data.taxon_id > 0}
                                <option value="{$data.taxon_id}" selected>{$data.taxon_name}</option>
                            {/if}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="taxon_name"  class="control-label col-md-4"> {t}Nom du taxon :{/t}<span class="red">*</span></label>
                    <div class="col-md-8">
                        <input id="taxon_name" type="text" class="form-control" name="taxon_name" value="{$data.taxon_name}" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="total_number"  class="control-label col-md-4"> {t}Nombre total :{/t}<span class="red">*</span></label>
                    <div class="col-md-8">
                        <input id="total_number" name="total_number" type="text" class="form-control nombre" value="{$data.total_number}" required>
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
                        <input id="sample_size_min" type="text" class="form-control taux" name="sample_size_min" value="{$data.sample_size_min}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="sample_size_max"  class="control-label col-md-4"> {t}Longueur maximale mesurée (cm) :{/t}</label>
                    <div class="col-md-8">
                        <input id="sample_size_max" type="text" class="form-control taux" name="sample_size_max" value="{$data.sample_size_max}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="sample_comment"  class="control-label col-md-4"> {t}Commentaires :{/t}</label>
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
                
            </fieldset>
        </div>
        <div class="col-md-6 form-horizontal">
            <fieldset>
                <legend>{t}Poisson mesuré{/t}{if $individual.individual_id > 0} - {t}N° : {/t}{$individual.individual_uid}{/if}</legend>
                <input type="hidden" id="individual_id" name="individual_id" value="{$individual.individual_id}">
                <input type="hidden" id="individualChange" name="individualChange" value=0>
                <div class="form-group" id="div-sl">
                    <label for="sl"  class="control-label col-md-4"> {t}Longueur standard (cm) :{/t}</label>
                    <div class="col-md-8">
                        <input id="sl" type="text" class="fish form-control taux" name="sl" value="{$individual.sl}" {if $sequence.measure_default == "sl"}autofocus{/if}>
                    </div>
                </div>
                <div class="form-group" id="div-fl">
                    <label for="fl"  class="control-label col-md-4"> {t}Longueur fourche (cm) :{/t}</label>
                    <div class="col-md-8">
                        <input id="fl" type="text" class="fish form-control taux" name="fl" value="{$individual.fl}" {if $sequence.measure_default == "fl"}autofocus{/if}>
                    </div>
                </div>
                <div class="form-group" id="div-tl">
                    <label for="tl"  class="control-label col-md-4"> {t}Longueur totale (cm) :{/t}</label>
                    <div class="col-md-8">
                        <input id="tl" type="text" class="fish form-control taux" name="tl" value="{$individual.tl}" {if $sequence.measure_default == "tl"}autofocus{/if}>
                    </div>
                </div>
                <div class="form-group" id="div-wd">
                    <label for="wd"  class="control-label col-md-4"> {t}Largeur disque (cm) :{/t}</label>
                    <div class="col-md-8">
                        <input id="wd" type="text" class="fish form-control taux" name="wd" value="{$individual.wd}" {if $sequence.measure_default == "wd"}autofocus{/if}>
                    </div>
                </div>
                <div class="form-group" id="div-ot">
                    <label for="ot"  class="control-label col-md-4"> {t}Autre longueur (cm) :{/t}</label>
                    <div class="col-md-8">
                        <input id="ot" type="text" class="fish form-control taux" name="ot" value="{$individual.ot}" {if $sequence.measure_default == "ot"}autofocus{/if}>
                    </div>
                </div>
                <div class="form-group">
                        <label for="measure_estimated"  class="control-label col-md-4">{t}Mesure estimée ?{/t}</label>
                        <div class="col-md-8" id="measure_estimated">
                            <label class="radio-inline">
                                <input  class="fish" type="radio" name="measure_estimated" id="measure_estimated0" value="0" {if $individual.measure_estimated == 0}checked{/if}>
                                {t}non{/t}
                            </label>
                            <label class="radio-inline">
                                <input class="fish" type="radio" name="measure_estimated" id="measure_estimated1" value="1" {if $individual.measure_estimated == 1}checked{/if}>
                                {t}oui{/t}
                            </label>
                        </div>
                    </div>
                <div class="form-group" id="div-weight">
                    <label for="weight"  class="control-label col-md-4"> {t}Poids (g) :{/t}</label>
                    <div class="col-md-8">
                        <input id="weight" type="text" class="fish form-control taux" name="weight" value="{$individual.weight}">
                    </div>
                </div>
                <div class="form-group" id="div-age">
                    <label for="age"  class="control-label col-md-4"> {t}Age (année) :{/t}</label>
                    <div class="col-md-8">
                        <input id="age" type="text" class="fish form-control nombre" name="age" value="{$individual.age}">
                    </div>
                </div>

                <div class="form-group">
                    <label for="sexe_id"  class="control-label col-md-4">{t}Sexe :{/t}</label>
                    <div class="col-md-8">
                        <select id="sexe_id" name="sexe_id" class="fish form-control">
                            <option value ="" {if $row.sexe_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
                            {foreach $sexes as $row}
                                <option value="{$row.sexe_id}" {if $row.sexe_id == $individual.sexe_id}selected{/if}>
                                {$row.sexe_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="pathology_id"  class="control-label col-md-4">{t}pathologie :{/t}</label>
                    <div class="col-md-8">
                        <select id="pathology_id" name="pathology_id" class="fish form-control combobox">
                            <option value ="" {if $row.pathology_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
                            {foreach $pathologys as $row}
                                <option value="{$row.pathology_id}" {if $row.pathology_id == $individual.pathology_id}selected{/if}>
                                {$row.pathology_code}:{$row.pathology_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group" id="div-pathology_codes">
                    <label for="pathology_codes"  class="fish control-label col-md-4"> {t}Pathologies (suite de codes) ou commentaires sur la pathologie :{/t}</label>
                    <div class="col-md-8">
                        <input id="pathology_codes" type="text" class="fish form-control" name="pathology_codes" value="{$individual.pathology_codes}">
                    </div>
                </div>

                <div class="form-group" id="div-tag">
                    <label for="tag"  class="control-label col-md-4"> {t}Marque lue :{/t}</label>
                    <div class="col-md-8">
                        <input id="tag" type="text" class="fish form-control" name="tag" value="{$individual.tag}">
                    </div>
                </div>
                <div class="form-group" id="div-tag_posed">
                    <label for="tag_posed"  class="control-label col-md-4"> {t}Marque posée :{/t}</label>
                    <div class="col-md-8">
                        <input id="tag_posed" type="text" class="fish form-control" name="tag_posed" value="{$individual.tag_posed}">
                    </div>
                </div>
                <div class="form-group" id="div-individual_comment">
                    <label for="individual_comment"  class="fish control-label col-md-4"> {t}Commentaires :{/t}</label>
                    <div class="col-md-8">
                        <textarea id="individual_comment" name="individual_comment" class="fish md-textarea form-control">{$individual.individual_comment}</textarea>
                    </div>
                </div>
                <div class="center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                    {if $individual.individual_id > 0 }
                        <button id="delete-individual" class="btn btn-danger">{t}Supprimer{/t}</button>
                    {/if}
                </div>
            </fieldset>
        </div>    
    </form>
</div>
    <div class="col-md-12">
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
                    {foreach $individuals as $individual}
                        <tr>
                            <td class="center">
                                <a href="index.php?module=sampleChange&sequence_id={$sequence.sequence_id}&operation_id={$sequence.operation_id}&sample_id={$individual.sample_id}&individual_id={$individual.individual_id}">
                                {$individual.individual_uid}
                                </a>
                            </td>
                            <td class="center">{$individual.sl}</td>
                            <td class="center">{$individual.fl}</td>
                            <td class="center">{$individual.tl}</td>
                            <td class="center">{$individual.wd}</td>
                            <td class="center">{$individual.ot}</td>
                            <td class="center">{$individual.weight}</td>  
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </fieldset>
    </div>
</div>
