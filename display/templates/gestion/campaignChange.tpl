<h2>{t}Création - Modification d'une campagne{/t}</h2>
<a href="index.php?module=campaignList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="campaign">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
            <div class="form-group">
                <label for="paramName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom de la campagne :{/t}</label>
                <div class="col-md-8">
                    <input id="paramName" type="text" class="form-control" name="campaign_name" value="{$data.campaign_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="project_id"  class="control-label col-md-4"><span class="red">*</span> {t}Projet :{/t}</label>
                <div class="col-md-8">
                    <select id="project_id" name="project_id" class="form-control">
                    {foreach $projects as $row}
                        <option value="{$row.project_id}" {if $row.project_id == $searchCampaign.project_id}selected{/if}>
                        {$row.project_name}
                        </option>
                    {/foreach}
                </select>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.campaign_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>