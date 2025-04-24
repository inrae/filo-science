<h2>{t}Création - Modification d'un projet{/t}</h2>
<div class="row">
      <div class="col-md-6">
            <a href="projectList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>

            <form class="form-horizontal " id="projectForm" method="post" action="projectWrite">
                  <input type="hidden" name="moduleBase" value="project">
                  <input type="hidden" name="project_id" value="{$data.project_id}">
                  <div class="form-group">
                        <label for="projectName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom :{/t}</label>
                        <div class="col-md-8">
                              <input id="projectName" type="text" class="form-control" name="project_name" value="{$data.project_name}" autofocus required>
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="metric_srid" class="control-label col-md-4">{t}Projection (SRID) utilisée pour convertir les coordonnées géographiques en système cartésien :{/t}</label>
                        <div class="col-md-8">
                              <input id="metric_srid" type="number" class="form-control" name="metric_srid" value="{$data.metric_srid}">
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="is_active" class="control-label col-md-4">{t}Actif ?{/t}</label>
                        <div class="col-md-8">
                              <input type="radio" name="is_active" value="1" {if $data.is_active == 1}checked{/if}>
                              oui
                              <input type="radio" name="is_active" value="0" {if $data.is_active == 0}checked{/if}>
                              non
                        </div>
                  </div>
                  <div class="form-group">
                        <label for="is_active" class="control-label col-md-4">{t}Protocole utilisé par défaut :{/t}</label>
                        <div class="col-md-8">
                              <select name="protocol_default_id" id="protocol_default_id" class="form-control">
                                    <option value="" {if $data.protocol_default_id == ""}selected{/if}>
                                          {t}Sélectionnez...{/t}
                                    </option>
                                    {foreach $protocols as $protocol}
                                          <option value="{$protocol.protocol_id}" {if $data.protocol_default_id == $protocol.protocol_id}selected{/if}>
                                                {$protocol.protocol_name}
                                          </option>
                                    {/foreach}
                              </select>
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
            {$csrf}</form>
      </div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>