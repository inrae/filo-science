<h2>{t}Création - Modification d'un projet{/t}</h2>
<div class="row">
      <div class="col-md-6">
            <a href="index.php?module=projectList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>

            <form class="form-horizontal protoform" id="projectForm" method="post" action="index.php">
                  <input type="hidden" name="moduleBase" value="project">
                  <input type="hidden" name="action" value="Write">
                  <input type="hidden" name="project_id" value="{$data.project_id}">
                  <div class="form-group">
                        <label for="projectName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
                        <div class="col-md-8">
                              <input id="projectName" type="text" class="form-control" name="project_name" value="{$data.project_name}" autofocus required>
                        </div>
                  </div>

                  <div class="form-group">
                        <label for="groupes"  class="control-label col-md-4">{t}Groupes :{/t}</label>
                        <div class="col-md-7">
                              {section name=lst loop=$groupes}
                                    <div class="col-md-2 col-sm-offset-3">
                                          <div class="checkbox">
                                                <label>
                                                <input type="checkbox" name="groupes[]" value="{$groupes[lst].aclgroup_id}" {if $groupes[lst].checked == 1}checked{/if}>
                                                {$groupes[lst].groupe}
                                                </label>
                                          </div>
                                    </div>
                              {/section}
                        </div>
                  </div>

                  <div class="form-group center">
                        <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                        {if $data.project_id > 0 }
                              <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                        {/if}
                  </div>
            </form>
      </div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>