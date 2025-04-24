<script>
	$(document).ready(function() {
		$("#documentSpinner").hide();
		$("#documentForm").submit(function(event) {
			$("#documentSpinner").show();
		});
	});
</script>

<div class="row">
	<form id="documentForm" class="form-horizontal protoform" method="post"
		action="index.php" enctype="multipart/form-data">
		<input type="hidden" name="document_id" value="0"> 
		<input type="hidden" name="module" value="{$moduleParent}documentWrite">
		<input type="hidden" name="parent_table" value="{$moduleParent}">
		<input type="hidden" name="parent_id" value="{$parent_id}">
		<input type="hidden" name="activeTab" value="tab-document">
		<input type="hidden" name="{$moduleParent}_id" value="{$parent_id}">
		<div class="form-group">
			<label for="documentName" class="control-label col-md-4">
				{t}Fichier(s) à importer :{/t} <br>(doc, jpg, png, pdf, xls, xlsx,
				docx, odt, ods, csv)
			</label>
			<div class="col-md-8">
				<input id="documentName" type="file" class="form-control"
					name="documentName[]" size="40" multiple>
			</div>
		</div>
		<div class="form-group">
			<label for="documentName" class="control-label col-md-4">
				{t}Description :{/t} </label>
			<div class="col-md-8">
				<input id="document_description" name="document_description" class="form-control">
			</div>
		</div>
		<div class="form-group">
			<label for="document_creation_date" class="control-label col-md-4">
				{t}Date de création du document :{/t} </label>
			<div class="col-md-8">
				<input id="document_creation_date" name="document_creation_date"
					class="form-control date">
			</div>
		</div>
		<div class="form-group center">
			<button type="submit" class="btn btn-primary">{t}Envoyer le fichier{/t}</button>
			<img id="documentSpinner" src="display/images/spinner.gif" height="25" >
		</div>
	{$csrf}</form>
</div>
