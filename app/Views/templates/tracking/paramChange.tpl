<h2>{t}Création - Modification d'un paramètre : {/t}{$tabledescription}</h2>
<a href="{$tablename}List"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<div class="row">
  <div class="col-md-6">
    <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
      <input type="hidden" name="moduleBase" value="{$tablename}">
      <input type="hidden" name="action" value="Write">
      <input type="hidden" name="{$fieldid}" value="{$data.$fieldid}">
      <div class="form-group">
        <label for="paramName" class="control-label col-md-4"><span class="red">*</span> {t}Libellé
          :{/t}</label>
        <div class="col-md-8">
          <input id="paramName" type="text" class="form-control" name="{$fieldname}" value="{$data.$fieldname}"
            autofocus required></div>
      </div>
      <div class="form-group center">
        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
        {if $data.$fieldid > 0 }
        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
        {/if}
      </div>
    {$csrf}</form>
  </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
