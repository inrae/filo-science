<script>
  $(document).ready(function(){
    $("#detectionRecalculate").submit(function(event){
      if(confirm("{t}Confirmez-vous l'opération ?{/t}")){
        $("#submit").hide();
        $("#spinner").show();
      } else {
        event.preventDefault();
      }
    });
  });
</script>
<h2>{t}Calcul du jour/nuit pour les détections{/t}</h2>
<div class="bg-info">{t}Attention : le calcul peut être long !{/t}</div>
<div class="row">
	<div class="col-lg-6 col-md-12">
		<form class="form-horizontal protoform" id="detectionRecalculate" action="index.php" method="POST">
			<input id="moduleSearch" type="hidden" name="module" value="detectionCalculateSunExec">
      <div class="form-group">
				<label for="project_id" class="col-md-2 control-label">{t}Projet :{/t}</label>
				<div class="col-md-4">
					<select id="project_id" name="project_id" class="form-control">
						{foreach $projects as $row}
						<option id="project{$row.project_id}" value="{$row.project_id}" {if $row.project_id == $project_id}selected{/if}>
							{$row.project_name}
						</option>
						{/foreach}
					</select>
				</div>
				<div class="col-md-2 col-md-offset-3 center">
					<input id="submit" type="submit" class="btn btn-success" value="{t}Lancer l'opération{/t}">
          <img id="spinner" src="display/images/spinner.gif" height="25" hidden>
				</div>
			</div>
    {$csrf}</form>
  </div>
</div>
