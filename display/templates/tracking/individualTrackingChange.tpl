<script type="text/javascript" src="display/javascript/formbuilder.js"></script>
<script>
    $(document).ready(function () {

        function getMetadata() {
            /*
                * Recuperation du modele de metadonnees rattache au type d'echantillon
                */
            var dataParse = $("#metadataField").val();
            dataParse = dataParse.replace(/&quot;/g, '"');
            dataParse = dataParse.replace(/\n/g, "\\n");
            if (dataParse.length > 2) {
                dataParse = JSON.parse(dataParse);
            }
            var schema;
            var protocolId = $("#protocol_id").val();
            var taxonId = $("#taxon_id").val();
            if (taxonId) {
                $.ajax({
                    url: "index.php",
                    data: { "module": "protocolGetTaxonTemplate", "protocol_id": protocolId, "taxon_id": taxonId }
                })
                    .done(function (value) {
                        if (value.length > 2) {
                            $("#complementaryData").prop("hidden", false);
                            var schema = value.replace(/&quot;/g, '"');
                            showForm(JSON.parse(schema), dataParse);
                            $(".alpaca-field-select").combobox();
                            setFocusOnDefaultField("", function () { });
                        } else {
                            $("#complementaryData").prop("hidden", true);
                        }
                    })
                    ;
            }
        }
        /* Taxon search */
        $("#taxon-search").keyup(function () {
            var name = $(this).val();
            if (name.length > 2) {
                var options = "";
                var url = "index.php";
                var data = {
                    "module": "taxonSearchAjax",
                    "name": name,
                    "freshwater": freshwater
                };
                $.ajax({
                    url: "index.php",
                    data: data
                })
                    .done(function (data) {
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
                if (taxonId != taxonIdInitial && taxonIdInitial > 0) {
                    $("#taxonChangeSpan").prop("hidden", false);
                }
                setTaxonName(taxonId);
                getMetadata();
            }
        });
        /*
         * set the name of the taxon
         */
        function setTaxonName(taxonId) {
            $.ajax({
                url: "index.php",
                data: { "module": "taxonGetName", "taxon_id": taxonId }
            })
                .done(function (value) {
                    if (value) {
                        var name = JSON.parse(value);
                        $("#taxon_name").val(name.scientific_name);
                        $("#taxonNameDisplay").text(name.scientific_name);
                    }
                });

        }
        $("#tag_posed").change(function () {
            var tag = $("#tag").val();
            var tagPosed = $(this).val();
            if (tag.length == 0 && tagPosed.length > 0) {
                $("#tag").val(tagPosed);
            }
        });
        /* Init metadata */
        getMetadata();
    });
</script>

<div class="col-md-6 form-horizontal">
<form id="lotform" method="post" action="index.php">
        <input type="hidden" name="moduleBase" value="sample">
        <input type="hidden" id="action" name="action" value="Write">
        <div class="form-group">
                <label for="taxon-search" class="control-label col-md-4"> {t}Code ou nom à rechercher :{/t}</label>
                <div class="col-md-8">
                    <input id="taxon-search" type="text" class="form-control" name="taxon-search" value="">
                </div>
            </div>
            <div class="form-group">
                <label for="taxon_id" class="control-label col-md-4"> {t}Taxon correspondant :{/t}</label>
                <div class="col-md-8">
                    <select id="taxon_id" class="form-control" name="taxon_id">
                        {if $data.taxon_id > 0}
                        <option value="{$data.taxon_id}" selected>{$data.taxon_name}</option>
                        {/if}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="taxon_name" class="control-label col-md-4"> <span
                        class="red">*</span>{t}Nom du taxon :{/t}</label>
                <div class="col-md-8">
                    <input id="taxon_name" type="text" class="form-control" name="taxon_name"
                        value="{$data.taxon_name}" required>
                </div>
            </div>
        <fieldset>
            <legend>{t}Poisson mesuré{/t}{if $individual.individual_id > 0} - {t}N° :
                {/t}{$individual.individual_uid}{/if} <i><span id="taxonNameDisplay">{$data.taxon_name}</span></i>
                {t}Mode automatique :{/t}&nbsp;<input type="checkbox" id="modeAuto">
                <button id="submit2" type="submit" class="btn btn-primary button-valid ">{t}Valider{/t}</button>
            </legend>
            <input type="hidden" id="individual_id" name="individual_id" value="{$individual.individual_id}">
            <input type="hidden" id="individualChange" name="individualChange" value=0>
            <input type="hidden" id="project_id" name="project_id" value="{$sequence.project_id}">
            <div class="form-group" id="div-sl">
                <label for="sl" class="control-label col-md-4"> {t}Longueur standard (mm) :{/t}</label>
                <div class="col-md-8">
                    <input id="sl" type="text" class="fish form-control taux" name="sl" value="{$individual.sl}" {if
                        $sequence.measure_default=="sl" }autofocus{/if} autocomplete="off">
                </div>
            </div>
            <div class="form-group" id="div-fl">
                <label for="fl" class="control-label col-md-4"> {t}Longueur fourche (mm) :{/t}</label>
                <div class="col-md-8">
                    <input id="fl" type="text" class="fish form-control taux" name="fl" value="{$individual.fl}" {if
                        $sequence.measure_default=="fl" }autofocus{/if} autocomplete="off">
                </div>
            </div>
            <div class="form-group" id="div-tl">
                <label for="tl" class="control-label col-md-4"> {t}Longueur totale (mm) :{/t}</label>
                <div class="col-md-8">
                    <input id="tl" type="text" class="fish form-control taux" name="tl" value="{$individual.tl}" {if
                        $sequence.measure_default=="tl" }autofocus{/if} autocomplete="off">
                </div>
            </div>
            <div class="form-group" id="div-wd">
                <label for="wd" class="control-label col-md-4"> {t}Largeur disque (mm) :{/t}</label>
                <div class="col-md-8">
                    <input id="wd" type="text" class="fish form-control taux" name="wd" value="{$individual.wd}" {if
                        $sequence.measure_default=="wd" }autofocus{/if} autocomplete="off">
                </div>
            </div>
            <div class="form-group" id="div-ot">
                <label for="ot" class="control-label col-md-4"> {t}Autre longueur (mm) :{/t}</label>
                <div class="col-md-8">
                    <input id="ot" type="text" class="fish form-control taux" name="ot" value="{$individual.ot}" {if
                        $sequence.measure_default=="ot" }autofocus{/if} autocomplete="off">
                </div>
            </div>
            <div class="form-group">
                <label for="measure_estimated" class="control-label col-md-4">{t}Mesure estimée ?{/t}</label>
                <div class="col-md-8" id="measure_estimated">
                    <label class="radio-inline">
                        <input class="fish" type="radio" name="measure_estimated" id="measure_estimated0" value="0"
                            {if $individual.measure_estimated==0}checked{/if}> {t}non{/t} </label> <label
                            class="radio-inline">
                        <input class="fish" type="radio" name="measure_estimated" id="measure_estimated1" value="1"
                            {if $individual.measure_estimated==1}checked{/if}> {t}oui{/t} </label> </div> </div>
                            <div class="form-group" id="div-weight">
                        <label for="weight" class="control-label col-md-4"> {t}Poids (g) :{/t}</label>
                        <div class="col-md-8">
                            <input id="weight" type="text" class="fish form-control taux" name="weight"
                                value="{$individual.weight}" autocomplete="off">
                        </div>
                </div>
                <div class="form-group" id="div-age">
                    <label for="age" class="control-label col-md-4"> {t}Age (année) :{/t}</label>
                    <div class="col-md-8">
                        <input id="age" type="text" class="fish form-control nombre" name="age"
                            value="{$individual.age}" autocomplete="off">
                    </div>
                </div>
                <fieldset id="complementaryData" hidden>
                    <legend>{t}Données complémentaires{/t}</legend>
                    <div class="form-group">
                        <div class="col-md-10 col-sm-offset-1">
                            <div id="metadata"></div>
                        </div>
                    </div>
                </fieldset>
                <div class="form-group">
                    <label for="sexe_id" class="control-label col-md-4">{t}Sexe :{/t}</label>
                    <div class="col-md-8">
                        <select id="sexe_id" name="sexe_id" class="fish form-control">
                            <option value="" {if $row.sexe_id=="" }selected{/if}>{t}Sélectionnez...{/t} </option>
                            {foreach $sexes as $row} 
                            <option value="{$row.sexe_id}" {if $row.sexe_id==$individual.sexe_id}selected{/if}> {$row.sexe_name} </option>
                            {/foreach} 
                        </select> 
                    </div> 
                </div> 
                <div class="form-group">
                    <label for="pathology_id" class="control-label col-md-4">{t}pathologie :{/t}</label>
                    <div class="col-md-8">
                        <select id="pathology_id" name="pathology_id" class="fish form-control combobox">
                            <option value="" {if $row.pathology_id==""}selected{/if}>{t}Sélectionnez...{/t} </option> 
                            {foreach $pathologys as $row} 
                                <option value="{$row.pathology_id}" {if $row.pathology_id==$individual.pathology_id}selected{/if}>
                                    {$row.pathology_code}:{$row.pathology_name}
                                </option> 
                            {/foreach}
                        </select> 
                    </div> 
                </div> 
                <div class="form-group" id="div-pathology_codes">
                    <label for="pathology_codes" class="fish control-label col-md-4">
                        {t}Pathologies (suite de codes) ou commentaires sur la pathologie :{/t}
                    </label>
                    <div class="col-md-8">
                        <input id="pathology_codes" type="text" class="fish form-control" name="pathology_codes" value="{$individual.pathology_codes}">
                    </div>
                </div>
                <div class="form-group" id="div-tag">
                    <label for="tag" class="control-label col-md-4"> {t}Marque lue :{/t}</label>
                    <div class="col-md-8">
                        <input id="tag" type="text" class="fish form-control" name="tag"
                            value="{$individual.tag}" autocomplete="off">
                    </div>
                </div>
                <div class="form-group" id="div-tag_posed">
                    <label for="tag_posed" class="control-label col-md-4"> {t}Marque posée
                        :{/t}</label>
                    <div class="col-md-8">
                        <input id="tag_posed" type="text" class="fish form-control" name="tag_posed"
                            value="{$individual.tag_posed}" autocomplete="off">
                    </div>
                </div>
                <div class="form-group" id="div-isTracking">
                    <label for="isTracking" class="control-label col-md-4">
                        {t}Poisson utilisé en télédétection ?{/t}</label>
                    <div class="col-md-8">
                        <input id="isTracking" type="checkbox" name="isTracking" class="fish" value="1">
                    </div>
                </div>
                <div class="form-group" id="div-transmitter" hidden>
                    <label for="transmitter" class="control-label col-md-4">
                        {t}Transmetteur posé :{/t}
                    </label>
                    <div class="col-md-8">
                        <select id="transmitter" name="transmitter_type_id" class="fish form-control">
                            <option value="" {if $individual.transmitter_type_id == ""}selected{/if}></option>
                            {foreach $transmitters as $transmitter}
                                <option value="{$transmitter.transmitter_type_id}" {if $transmitter.transmitter_type_id == $individual.transmitter_type_id}selected{/if}>
                                    {$transmitter.transmitter_type_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group" id="div-individual_comment">
                    <label for="individual_comment" class="fish control-label col-md-4">
                        {t}Commentaires :{/t}</label>
                    <div class="col-md-8">
                        <textarea id="individual_comment" name="individual_comment"
                            class="fish md-textarea form-control">{$individual.individual_comment}</textarea>
                    </div>
                </div>
                <div class="center">
                    <button id="submit3" type="submit" class="btn btn-primary button-valid ">{t}Valider{/t}</button>
                    {if $individual.individual_id > 0 }
                        <button id="delete-individual" class="btn btn-danger ">{t}Supprimer{/t}</button>
                    {/if}
                </div>
        </fieldset>
    </div>
</form>
</div>