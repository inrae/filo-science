{include file="param/metadataFormJS.tpl"}
<script type="text/javascript">
  $(document).ready(function () {

    var metadataParse = $("#metadataField").val();
    if (metadataParse.length > 0) {
      metadataParse = metadataParse.replace(/&quot;/g, '"');
      metadataParse = JSON.parse(metadataParse);
    }
    renderForm(metadataParse);

    $('#metadataForm').submit(function (event) {
      console.log("write");
      if ($("#action").val() == "Write") {
        $('#metadata').alpaca().refreshValidationState(true);
        if (!$('#metadata').alpaca().isValid(true)) {
          alert("{t}La définition des métadonnées n'est pas valide.{/t}");
          event.preventDefault();
        }
      }
    });
  });
</script>

<h2>{t}Création - Modification d'un modèle de mesures complémentaires d'ambiance{/t}</h2>
<div class="row">
  <div class="col-md-6">
    <a href="ambienceTemplateList">{t}Retour à la liste{/t}</a>
    <form class="form-horizontal " id="metadataForm" method="post" action="ambienceTemplateWrite"
      enctype="multipart/form-data">
      <input type="hidden" name="moduleBase" value="ambienceTemplate">
      <input type="hidden" name="ambience_template_id" value="{$data.ambience_template_id}">
      <input type="hidden" name="ambience_template_schema" id="metadataField" value="{$data.ambience_template_schema}">
      <div class="form-group">
        <label for="metadataName" class="control-label col-md-4">
          <span class="red">*</span> {t}Nom du modèle:{/t}</label>
        <div class="col-md-8">
          <input id="metadataName" type="text" class="form-control" name="ambience_template_name"
            value="{$data.ambience_template_name}" required autofocus>
        </div>
      </div>
      <fieldset>
        <legend>{t}Champs de mesures complémentaires{/t}</legend>
        <div id="metadata"></div>
      </fieldset>
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        {if $data.ambience_template_id > 0 }
        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        {/if}
      </div>
    {$csrf}</form>
  </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>