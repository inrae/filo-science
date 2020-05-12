<script type="text/javascript" src="display/javascript/formbuilder.js"></script>
<script>
	$(document).ready(function () {
		/* hide fields measures if necessary */
		var mdo = "{$project.measure_default_only}";
		var md = "{$project.measure_default}";
		if (mdo == "1") {
			var lengths = ["sl", "fl", "tl", "wd", "ot"];
			for (var i = 0; i < 5; i++) {
				if (md != lengths[i]) {
					$("#div-" + lengths[i]).hide();
				}
			}
		}
		var isAuto = Cookies.get("fishAutoMode");
		if (isAuto === undefined) {
			isAuto = 1;
			Cookies.set("fishAutoMode", 1, { expires: 180 });
		}
		if (isAuto == "1") {
			$("#modeAuto").prop("checked", true);
		} else {
			$("#modeAuto").prop("checked", false);
		}
		var defaultField = "{$project.measure_default}";
		var transmitter_type_id = "{$data.transmitter_type_id}";
		if (transmitter_type_id == "") {
			/* get the cookie */
			try {
				transmitter_type_id = Cookies.get("transmitter_type_id");
				if (transmitter_type_id != undefined) {
					$("#transmitter_type_id option[value="+transmitter_type_id+"]").prop("selected", "selected");
				}
			} catch {}
		}
		function getMetadata(taxonId) {
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
			if (taxonId && taxonId > 0) {
				$.ajax({
					url: "index.php",
					data: { "module": "protocolGetTaxonTemplate", "protocol_id": protocolId, "taxon_id": taxonId }
				})
					.done(function (value) {
						if (value.length > 2) {
							$("#complementaryData").prop("hidden", false);
							var schema = value.replace(/&quot;/g, '"');
              console.log (schema);
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
					"noFreshcode": 1
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
			setTaxonId(taxonId);
		});
		function setTaxonId(taxonId) {
			if (taxonId > 0) {
				Cookies.set("taxon_id", taxonId, { expires: 7});
				$("#taxon_id").val(taxonId);
				setTaxonName(taxonId);
				getMetadata(taxonId);
			}
		}
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
			var tagPosed = $(this).val().toUpperCase();
			if (tag.length == 0 && tagPosed.length > 0) {
				$("#tag").val(tagPosed);
			}
			$(this).val(tagPosed.toUpperCase());
		});
		$("#tag,#transmitter").change(function () {
			$(this).val($(this).val().toUpperCase());
		});
		function setFocusOnDefaultField(test, callback) {
			if (defaultField.length > 0) {
				$("#".defaultField).focus();
				$("#".defaultField).prop("autofocus", true);
				callback();
			}
		}
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
		$("#transmitter_type_id").change(function() {
			Cookies.set("transmitter_type_id",$(this).val(), { expires: 180});
		});
		$("#individualForm").submit(function (event) {
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

		/* get the default taxon_id*/
		var taxon_id = "{$data.taxon_id}";
		if (! taxon_id > 0) {
			try {
				taxon_id = Cookies.get("taxon_id");
				console.log("taxon_id:"+taxon_id);
				if (taxon_id != undefined) {
					$.ajax({
						url: "index.php",
						data: { "module": "taxonGetName", "taxon_id": taxon_id }
					})
					.done(function (value) {
						if (value) {
							var name = JSON.parse(value);
							$("#taxon_name").val(name.scientific_name);
							$("#taxonNameDisplay").text(name.scientific_name);
							var option = '<option value="'+taxon_id+'" selected>'+name.scientific_name+'</option>';
							$("#taxon_id").html(option);
							getMetadata(taxon_id);
						}
					});
				}
			} catch {}
		} else {
			/* Init metadata */
		getMetadata(taxon_id);
		}
    $("#individual_code").change(function () {
      $("#codeDisplay").text($(this).val());
    });
	});
</script>
<div class="row">
	<div class="col-md-12">
		<a href="index.php?module=individualTrackingList">
			<img src="display/images/list.png" height="25">
			{t}Retour à la liste{/t}
		</a>
	</div>
</div>

<div class="col-md-6 form-horizontal">
	<form id="individualForm" method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="individualTracking">
			<input type="hidden" id="action" name="action" value="Write">
			<input type="hidden" id="isTracking" name="isTracking" value="1">
			<div class="col-md-4 center">{t}Mode automatique :{/t}&nbsp;<input type="checkbox" id="modeAuto"></div>
			<div class="col-md-8 center"><button id="submit2" type="submit" class="btn btn-primary button-valid ">{t}Valider{/t}</button></div>
			<fieldset>
				<legend>{t}Taxon{/t}</legend>
					<div class="form-group">
					<label for="taxon-search" class="control-label col-md-4"> {t}Code ou nom à rechercher :{/t}</label>
					<div class="col-md-8">
						<input id="taxon-search" type="text" class="form-control" name="taxon-search" value="" autocomplete="off">
					</div>
				</div>
				<div class="form-group">
					<label for="taxon_id" class="control-label col-md-4"> {t}Taxon correspondant :{/t}</label>
					<div class="col-md-8">
						<select id="taxon_id" class="form-control" name="taxon_id">
							{if $data.taxon_id > 0}
								<option value="{$data.taxon_id}" selected>{$data.scientific_name}</option>
							{/if}
						</select>
					</div>
				</div>
				<div class="form-group">
					<label for="taxon_name" class="control-label col-md-4"> <span
							class="red">*</span>{t}Nom du taxon :{/t}</label>
					<div class="col-md-8">
						<input id="taxon_name" type="text" class="form-control" name="taxon_name"
							value="{$data.scientific_name}" required>
					</div>
				</div>
			</fieldset>
			<fieldset>
				<legend>{t}Poisson mesuré{/t}{if $data.individual_id > 0} - {t}N° :{/t}&nbsp;{$data.individual_uid}{/if} <i><span id="taxonNameDisplay">{$data.scientific_name}</span></i>&nbsp;<span id="codeDisplay">{$data.individual_code}</span>
				</legend>
				<input type="hidden" id="individual_id" name="individual_id" value="{$data.individual_id}">
				<input type="hidden" id="individualChange" name="individualChange" value=0>
				<input type="hidden" id="project_id" name="project_id" value="{$project.project_id}">
				<input type="hidden" id="protocol_id" value="{$project.protocol_default_id}">
				<input type="hidden" name="other_measure" id="metadataField" value="{$data.other_measure}">
				<div class="form-group" id="div-sl">
					<label for="sl" class="control-label col-md-4"> {t}Longueur standard (mm) :{/t}</label>
					<div class="col-md-8">
						<input id="sl" type="text" class="fish form-control taux" name="sl" value="{$data.sl}" {if $sequence.measure_default=="sl" }autofocus{/if} autocomplete="off">
					</div>
				</div>
				<div class="form-group" id="div-fl">
					<label for="fl" class="control-label col-md-4"> {t}Longueur fourche (mm) :{/t}</label>
					<div class="col-md-8">
						<input id="fl" type="text" class="fish form-control taux" name="fl" value="{$data.fl}" {if $sequence.measure_default=="fl" }autofocus{/if} autocomplete="off">
					</div>
				</div>
				<div class="form-group" id="div-tl">
					<label for="tl" class="control-label col-md-4"> {t}Longueur totale (mm) :{/t}</label>
					<div class="col-md-8">
						<input id="tl" type="text" class="fish form-control taux" name="tl" value="{$data.tl}" {if $sequence.measure_default=="tl" }autofocus{/if} autocomplete="off">
					</div>
				</div>
				<div class="form-group" id="div-wd">
					<label for="wd" class="control-label col-md-4"> {t}Largeur disque (mm) :{/t}</label>
					<div class="col-md-8">
						<input id="wd" type="text" class="fish form-control taux" name="wd" value="{$data.wd}" {if $sequence.measure_default=="wd" }autofocus{/if} autocomplete="off">
					</div>
				</div>
				<div class="form-group" id="div-ot">
					<label for="ot" class="control-label col-md-4"> {t}Autre longueur (mm) :{/t}</label>
					<div class="col-md-8">
						<input id="ot" type="text" class="fish form-control taux" name="ot" value="{$data.ot}" {if $sequence.measure_default=="ot" }autofocus{/if} autocomplete="off">
					</div>
				</div>
				<div class="form-group">
					<label for="measure_estimated" class="control-label col-md-4">{t}Mesure estimée ?{/t}</label>
					<div class="col-md-8" id="measure_estimated">
						<label class="radio-inline">
							<input class="fish" type="radio" name="measure_estimated" id="measure_estimated0" value="0" {if $data.measure_estimated==0}checked{/if}> {t}non{/t}
						</label>
						<label class="radio-inline">
							<input class="fish" type="radio" name="measure_estimated" id="measure_estimated1" value="1" {if $data.measure_estimated==1}checked{/if}> {t}oui{/t}
						</label>
					</div>
				</div>
				<div class="form-group" id="div-weight">
					<label for="weight" class="control-label col-md-4"> {t}Poids (g) :{/t}</label>
					<div class="col-md-8">
						<input id="weight" type="text" class="fish form-control taux" name="weight" value="{$data.weight}" autocomplete="off">
					</div>
				</div>
				<div class="form-group" id="div-age">
					<label for="age" class="control-label col-md-4"> {t}Age (année) :{/t}</label>
					<div class="col-md-8">
						<input id="age" type="text" class="fish form-control nombre" name="age" value="{$data.age}" autocomplete="off">
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
							<option value="{$row.sexe_id}" {if $row.sexe_id==$data.sexe_id}selected{/if}> {$row.sexe_name} </option>
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
								<option value="{$row.pathology_id}" {if $row.pathology_id==$data.pathology_id}selected{/if}>
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
						<input id="pathology_codes" type="text" class="fish form-control" name="pathology_codes" value="{$data.pathology_codes}">
					</div>
        </div>
        	<div class="form-group" id="div-individual-code">
            <label for="individual_code" class="control-label col-md-4"> {t}Code du poisson :{/t}</label>
            <div class="col-md-8">
              <input id="individual_code" type="text" class="fish form-control" name="individual_code" value="{$data.individual_code}" autocomplete="off">
            </div>
          </div>
				<div class="form-group" id="div-tag">
					<label for="tag" class="control-label col-md-4"> {t}Marque RFID lue :{/t}</label>
					<div class="col-md-8">
						<input id="tag" type="text" class="fish form-control" name="tag" value="{$data.tag}" autocomplete="off">
					</div>
				</div>
				<div class="form-group" id="div-tag_posed">
					<label for="tag_posed" class="control-label col-md-4"> {t}Marque RFID posée :{/t}</label>
					<div class="col-md-8">
						<input id="tag_posed" type="text" class="fish form-control" name="tag_posed" value="{$data.tag_posed}" autocomplete="off">
					</div>
				</div>
				<div class="form-group" id="div-transmitter">
					<label for="transmitter" class="control-label col-md-4"> {t}Code du transmetteur acoustique ou radio posé ou existant :{/t}</label>
					<div class="col-md-8">
						<input id="transmitter" type="text" class="fish form-control" name="transmitter"
							value="{$data.transmitter}" autocomplete="off">
					</div>
				</div>
				<div class="form-group" id="div-transmitter-type">
					<label for="transmitter" class="control-label col-md-4">
						{t}Modèle de transmetteur posé :{/t}
					</label>
					<div class="col-md-8">
						<select id="transmitter_type_id" name="transmitter_type_id" class="fish form-control">
							<option value="" {if $data.transmitter_type_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
							{foreach $transmitters as $transmitter}
								<option value="{$transmitter.transmitter_type_id}" {if $transmitter.transmitter_type_id == $data.transmitter_type_id}selected{/if}>
									{$transmitter.transmitter_type_name} <i>{$transmitter.technology}</i>
								</option>
							{/foreach}
						</select>
					</div>
				</div>
				<div class="form-group" id="div-individual_comment">
					<label for="individual_comment" class="fish control-label col-md-4">
						{t}Commentaires :{/t}</label>
					<div class="col-md-8">
						<textarea id="individual_comment" name="individual_comment" class="fish md-textarea form-control">{$data.individual_comment}</textarea>
					</div>
				</div>
				<div class="form-group" id="div-uuid">
					<label for="uuid" class="fish control-label col-md-4">
						{t}Identifiant unique :{/t}</label>
					<div class="col-md-8">
						<input id="uuid" name="uuid" value="{$data.uuid}" class="fish form-control">
					</div>
				</div>
				<div class="center">
					<button id="submit3" type="submit" class="btn btn-primary button-valid ">{t}Valider{/t}</button>
					{if $data.individual_id > 0 }
						<button id="delete-individual" class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
					{/if}
				</div>
			</fieldset>
		</div>
	</form>
</div>