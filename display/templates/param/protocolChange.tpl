<h2>{t}Création - Modification d'un protocole{/t}</h2>
<a href="index.php?module=protocolList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
{if $data.protocol_id > 0}
	&nbsp;<a href="index.php?module=protocolDisplay&protocol_id={$data.protocol_id}">
			<img src="display/images/display.png" height="25">{t}Retour au détail{/t}
		</a>
{/if}
<div class="row">
	<div class="col-md-6">

		<form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
			<input type="hidden" name="moduleBase" value="protocol">
			<input type="hidden" name="action" value="Write">
			<input type="hidden" name="protocol_id" value="{$data.protocol_id}">
			<div class="form-group">
				<label for="paramName"  class="control-label col-md-4"><span class="red">*</span> {t}Libellé :{/t}</label>
				<div class="col-md-8">
					<input id="paramName" type="text" class="form-control" name="protocol_name" value="{$data.protocol_name}" autofocus required>
				</div>
			</div>
			<div class="form-group">
				<label for="protocol_description"  class="control-label col-md-4">{t}Description :{/t}</label>
				<div class="col-md-8">
					<textarea id="protocol_description" class="md-textarea form-control" name="protocol_description" >{$data.protocol_description}</textarea>
				</div>
			</div>
			<div class="form-group">
				<label for="protocol_url"  class="control-label col-md-4">{t}Lien d'accès au protocole :{/t}</label>
				<div class="col-md-8">
					<input id="protocol_url" type="text" class="form-control" name="protocol_url" value="{$data.protocol_url}" >
				</div>
			</div>
			<div class="form-group">
				<label for="measure_default"  class="control-label col-md-4"><span class="red">*</span> {t}Mesure de longueur réalisée par défaut :{/t}</label>
				<div class="col-md-8">
					<select id="measure_default" name="measure_default" class="form-control">
						<option value="sl" {if $data.measure_default == "sl"}selected{/if}>{t}Longueur standard{/t}</option>
						<option value="fl" {if $data.measure_default == "fl"}selected{/if}>{t}Longueur fourche{/t}</option>
						<option value="tl" {if $data.measure_default == "tl"}selected{/if}>{t}Longueur totale{/t}</option>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label for="measure_default_only"  class="control-label col-md-4">{t}Seule la longueur par défaut est autorisée ?{/t}</label>
				<div class="col-md-8" id="measure_default_only">
					<label class="radio-inline">
						<input  type="radio" name="measure_default_only" id="measure_default_only1" value="1" {if $data.measure_default_only == 1}checked{/if}>
						{t}oui{/t}
					</label>
					<label class="radio-inline">
						<input  type="radio" name="measure_default_only" id="measure_default_only2" value="0" {if $data.measure_default_only == 0}checked{/if}>
						{t}non{/t}
					</label>
				</div>
			</div>
			<div class="form-group">
				<label for="existing_taxon_only"  class="control-label col-md-4">{t}Seuls les taxons existants sont autorisés ?{/t}</label>
				<div class="col-md-8" id="measure_default_only">
					<label class="radio-inline">
						<input  type="radio" name="existing_taxon_only" id="existing_taxon_only1" value="1" {if $data.existing_taxon_only == 1}checked{/if}>
						{t}oui{/t}
					</label>
					<label class="radio-inline">
						<input  type="radio" name="existing_taxon_only" id="existing_taxon_only2" value="0" {if $data.existing_taxon_only == 0}checked{/if}>
						{t}non{/t}
					</label>
				</div>
			</div>
			<div class="form-group">
				<label for="analysis_template_id" class="control-label col-md-4">{t}Modèle d'analyse complémentaire :{/t}</label>
				<div class="col-md-8">
					<select id="analysis_template_id" name="analysis_template_id" class="form-control">
						<option value="" {if $data.analysis_template_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
						{foreach $dataat as $row}
							<option value="{$row.analysis_template_id}" {if $row.analysis_template_id == $data.analysis_template_id}selected{/if}>
								{$row.analysis_template_name}
							</option>
						{/foreach}
					</select>
				</div>
			</div>
      <div class="form-group">
				<label for="ambience_template_id" class="control-label col-md-4">{t}Modèle de mesures complémentaires d'ambiance :{/t}</label>
				<div class="col-md-8">
					<select id="ambience_template_id" name="ambience_template_id" class="form-control">
						<option value="" {if $data.ambience_template_id == ""}selected{/if}>{t}Sélectionnez...{/t}</option>
						{foreach $ambiences as $row}
							<option value="{$row.ambience_template_id}" {if $row.ambience_template_id == $data.ambience_template_id}selected{/if}>
								{$row.ambience_template_name}
							</option>
						{/foreach}
					</select>
				</div>
			</div>
			<div class="form-group center">
				<button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
				{if $data.protocol_id > 0 }
					<button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
				{/if}
			</div>
		</form>
	</div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>