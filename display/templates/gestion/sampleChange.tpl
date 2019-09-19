<script type="text/javascript" src="display/javascript/formbuilder.js"></script>
<script>
    $(document).ready(function () {
        var mapIsChange = true;
        var freshwater = "{$sequence.freshwater}";
        var taxonIdInitial = parseInt("{$data.taxon_id}");
        var sampleId = parseInt("{$data.sample_id}");
        var isHide = false;
        var isAuto = Cookies.get("fishAutoMode");
        var defaultField = "{$sequence.measure_default}";
        if (isAuto === undefined) {
            isAuto = 1;
            Cookies.set("fishAutoMode", 1, { expires: 180 });
        }
        if (isAuto == "1") {
            $("#modeAuto").prop("checked", true);
        } else {
            $("#modeAuto").prop("checked", false);
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

        /* hide fields measures if necessary */
        var mdo = "{$sequence.measure_default_only}";
        var md = "{$sequence.measure_default}";
        if (mdo == "1") {
            var lengths = ["sl", "fl", "tl", "wd", "ot"];
            for (var i = 0; i < 5; i++) {
                if (md != lengths[i]) {
                    $("#div-" + lengths[i]).hide();
                }
            }
        }

        /* Generate the change trigger for individual */
        $(".fish").change(function () {
            $("#individualChange").val(1);
        });

        /* Delete an individual */
        $("#delete-individual").on('keyup click', function () {
            var lib = "{t}Confirmez-vous la suppression ?{/t}";
            if (confirm(lib) == true) {
                $(this.form).find("input[name='action']").val("DeleteIndividual");
                $(this.form).submit();
            } else {
                return false;
            }
        });
        /*
         * Initialisation when it's a new taxon
         */
        if (taxonIdInitial > 0 && sampleId == 0) {
            $("#taxon_id").val(taxonIdInitial);
            setTaxonName(taxonIdInitial);
        }

        $(".taxonselect").on("click", function () {
            /**
             * Generate a new lot with the selected taxon
             */
            var code = $(this).text();
            $.ajax({
                url: "index.php",
                data: { "module": "taxonGetFromCode", "freshwater": freshwater, "code": code }
            })
                .done(function (value) {
                    if (value) {
                        var name = JSON.parse(value);
                        $("#taxon_id_new").val(name.taxon_id);
                        $("#action").val("Change");
                        $("#sample_id").val("0");
                        $("#lotform").submit();
                        /*$("#taxon_name").val(name.scientific_name);
                        option = '<option value="' + name.taxon_id + '">' + name.scientific_name;
                        if (name.common_name.length > 0) {
                            option += ' (' + name.common_name + ')';
                        }
                        option += '</option>';
                        $("#taxon_id").html(option);*/
                    }
                });
        });
        /**
         * hide some components where the screen is too small
         */
        if (screen.width <= 800) {
            $(".hideable").hide();
            isHide = true;
            $("#button-hide").text("{t}Afficher{/t}");
        }
        $("#button-hide").on("click", function (event) {
            event.preventDefault();
            if (isHide) {
                $(".hideable").show();
                $("#button-hide").text("{t}Masquer{/t}");
                isHide = false;
            } else {
                $(".hideable").hide();
                isHide = true;
                $("#button-hide").text("{t}Afficher{/t}");
            }
        });
        /**
         * erase the + as first character in numeric fields
         * for calliper
         */
        $(".fish").on("change paste keyup", function (e) {
            var val = $(this).val();
            if (val.charAt(0) == "+") {
                val = val.substr(1, val.length - 1);
                $(this).val(val);
            }
        });

        $(".fish").hover(function () {
            $(this).focus();
        });
       
        $(".btn").click(function( event ) { 
            if ($(this).prop("id") != $(':focus').prop("id") && isAuto == 0) {
                event.preventDefault();
            }
        });

        $("#modeAuto").on("change", function () {
            if ($(this).prop("checked")) {
                isAuto = 1;
                Cookies.set("fishAutoMode", 1, { expires: 180 });
            } else {
                isAuto = 0;
                Cookies.set("fishAutoMode", 0, { expires: 180 });
            }
        });
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

        $("#lotform").submit(function (event) {
            if ($("#action").val() == "Write") {
                var error = false;
                try {
                    $('#metadata').alpaca().refreshValidationState(true);
                    if ($('#metadata').alpaca().isValid()) {
                        var value = $('#metadata').alpaca().getValue();
                        // met les metadata en JSON dans le champ (name="metadata") qui sera sauvegardé en base
                        $("#metadataField").val(JSON.stringify(value));
                        if ($("#metadataField").val().length > 0) {
                            $("#individualChange").val(1);
                        }
                    } else {
                        error = true;
                    }
                    if (error) {
                        event.preventDefault();
                    }
                } catch (e) { }
            }
        });
        function setFocusOnDefaultField(test, callback) {
            if (defaultField.length > 0) {
                $("#".defaultField).focus();
                $("#".defaultField).prop("autofocus", true);
                callback();
            }
        }
        /* Init metadata */
        getMetadata();
    });
</script>

<div class="row">
    <div class="col-md-12">
        <span class="hidden-xs hidden-sm">
            <a href="index.php?module=campaignDisplay&campaign_id={$sequence.campaign_id}"><img
                    src="display/images/display-red.png" height="25">
                {t}Retour à la campagne{/t} {$sequence.campaign_name}
            </a>
            &nbsp;
            <a
                href="index.php?module=operationDisplay&campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}&activeTab=tab-sequence">
                <img src="display/images/display-green.png" height="25">{t}Retour à l'opération{/t}
                {$sequence.operation_name}
            </a>
            &nbsp;
        </span>
        <a
            href="index.php?module=sequenceDisplay&campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}&sequence_id={$sequence.sequence_id}&activeTab=tab-sample">
            <img src="display/images/display.png" height="25">{t}Retour à la séquence{/t} {$sequence.sequence_number}
        </a>
        <div class="hidden-xs hidden-sm"><br></div>
        &nbsp;
        <a
            href="index.php?module=sampleChange&sequence_id={$sequence.sequence_id}&operation_id={$sequence.operation_id}&sample_id=0">
            <img src="display/images/new.png" height="25">{t}Nouveau lot{/t}
        </a>
        &nbsp;
        <a
            href="index.php?module=sampleChange&sequence_id={$sequence.sequence_id}&operation_id={$sequence.operation_id}&sample_id={$data.sample_id}&individual_id=0">
            <img src="display/images/fish.png" height="25">{t}Nouvelle capture{/t}
        </a>

    </div>

</div>
<div class="row col-md-12">
    <form id="lotform" method="post" action="index.php">
        <div class="col-md-6 form-horizontal">
            {if count($grid) > 0}
            <fieldset>
                <legend>{t}Création d'un nouveau lot{/t}</legend>
                {for $line = 1 to 4}
                <div class="row">
                    {for $column = 1 to 6}
                    <div class="col-sm-2 center">
                        {if strlen($grid[$line][$column]) > 0}
                        <button id="grid{$line}-{$column}" type="button" class="btn btn-info taxonselect">{$grid[$line][$column]}</button>
                        {/if}
                    </div>
                    {/for}
                </div>
                {/for}
            </fieldset>
            {/if}
            <fieldset>
                <legend>
                    {t}Détail du lot n°{/t} {$data.sample_uid}
                    <span id="taxonChangeSpan" class="red" hidden>
                        <img src="display/images/caution.png">
                        {t}Changement de taxon{/t}
                    </span>
                </legend>
                <input type="hidden" name="moduleBase" value="sample">
                <input type="hidden" id="action" name="action" value="Write">
                <input type="hidden" name="sequence_id" value="{$sequence.sequence_id}">
                <input type="hidden" id="sample_id" name="sample_id" value="{$data.sample_id}">
                <input type="hidden" name="taxon_id_new" value="0" id="taxon_id_new">
                <input type="hidden" name="other_measure" id="metadataField" value="{$individual.other_measure}">
                <input type="hidden" id="protocol_id" value="{$sequence.protocol_id}">

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
                    <label for="taxon_name" class="control-label col-md-4"> {t}Nom du taxon :{/t}<span
                            class="red">*</span></label>
                    <div class="col-md-8">
                        <input id="taxon_name" type="text" class="form-control" name="taxon_name"
                            value="{$data.taxon_name}" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="total_number" class="control-label col-md-4"> {t}Nombre total :{/t}<span
                            class="red">*</span></label>
                    <div class="col-md-8">
                        <input id="total_number" name="total_number" type="text" class="form-control nombre"
                            value="{$data.total_number}" required>
                    </div>
                </div>
                <div class="form-group hideable">
                    <label for="total_measured" class="control-label col-md-4"> {t}Nombre mesurés :{/t}</label>
                    <div class="col-md-8">
                        <input id="total_measured" type="text" class="form-control nombre" name="total_measured"
                            value="{$data.total_measured}" autocomplete="off">
                    </div>
                </div>
                <div class="form-group hideable">
                    <label for="total_weight" class="control-label col-md-4"> {t}Poids total (g) :{/t}</label>
                    <div class="col-md-8">
                        <input id="total_weight" type="text" class="form-control nombre" name="total_weight"
                            value="{$data.total_weight}" autocomplete="off">
                    </div>
                </div>
                <div class="form-group hideable">
                    <label for="sample_size_min" class="control-label col-md-4"> {t}Longueur minimale mesurée (mm)
                        :{/t}</label>
                    <div class="col-md-8">
                        <input id="sample_size_min" type="text" class="form-control taux" name="sample_size_min"
                            value="{$data.sample_size_min}">
                    </div>
                </div>
                <div class="form-group hideable">
                    <label for="sample_size_max" class="control-label col-md-4"> {t}Longueur maximale mesurée (mm)
                        :{/t}</label>
                    <div class="col-md-8">
                        <input id="sample_size_max" type="text" class="form-control taux" name="sample_size_max"
                            value="{$data.sample_size_max}">
                    </div>
                </div>
                <div class="form-group hideable">
                    <label for="sample_comment" class="control-label col-md-4"> {t}Commentaires :{/t}</label>
                    <div class="col-md-8">
                        <textarea id="sample_comment" type="text" class="form-control"
                            name="sample_comment">{$data.sample_comment}</textarea>
                    </div>
                </div>
                <div class="form-group center">
                    <button id="submit1" type="submit" class="btn btn-primary button-valid ">{t}Valider{/t}</button>
                    {if $data.sample_id > 0 }
                        <button id="delete1" class="btn btn-danger button-delete ">{t}Supprimer{/t}</button>
                    {/if}
                    <button id="mask" class="btn btn-secondary" id="button-hide" title="{t}Informations complémentaires du lot{/t}">{t}Masquer{/t}</button>
                </div>
            </fieldset>
        </div>

        <div class="col-md-6 form-horizontal">
            <fieldset>
                <legend>{t}Poisson mesuré{/t}{if $individual.individual_id > 0} - {t}N° :
                    {/t}{$individual.individual_uid}{/if} <i><span id="taxonNameDisplay">{$data.taxon_name}</span></i>
                    {t}Mode automatique :{/t}&nbsp;<input type="checkbox" id="modeAuto">
                    <button id="submit2" type="submit" class="btn btn-primary button-valid ">{t}Valider{/t}</button>
                </legend>
                <input type="hidden" id="individual_id" name="individual_id" value="{$individual.individual_id}">
                <input type="hidden" id="individualChange" name="individualChange" value=0>
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
                <th>{t}Mesures complémentaires{/t}</th>
            </thead>
            <tbody>
                {foreach $individuals as $individual}
                <tr>
                    <td class="center">
                        <a
                            href="index.php?module=sampleChange&sequence_id={$sequence.sequence_id}&operation_id={$sequence.operation_id}&sample_id={$individual.sample_id}&individual_id={$individual.individual_id}">
                            {$individual.individual_uid}
                        </a>
                    </td>
                    <td class="center">{$individual.sl}</td>
                    <td class="center">{$individual.fl}</td>
                    <td class="center">{$individual.tl}</td>
                    <td class="center">{$individual.wd}</td>
                    <td class="center">{$individual.ot}</td>
                    <td class="center">{$individual.weight}</td>
                    <td>{$individual.other_measures}</td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </fieldset>
</div>
</div>