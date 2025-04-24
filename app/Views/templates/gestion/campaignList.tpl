<script>
    $(document).ready(function() {
        $(".checkSelect").change(function() {
            $('.check').prop('checked', this.checked);
        });
    });
</script>
<h2>{t}Liste des campagnes{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {include file="gestion/campaignSearch.tpl" }
    </div>
</div>
<form id="exportForm" method="post" action="index.php">
    <input type="hidden" name="moduleBase" value="export">
    <input type="hidden" name="action" value="Exec">
    <input type="hidden" name="returnko" value="campaignList">
    <input type="hidden" name="translator" value="ti_campaign">

    <div class="row">
        <div class="col-md-6">
            {if $rights.manage == 1}
                <img src="display/images/new.png" height="25">
                <a href="campaignChange&campaign_id=0">
                    {t}Nouveau...{/t}
                </a>
            {/if}
            {if $isSearch == 1}
                <table id="paramList" class="table table-bordered table-hover datatable " >
                    <thead>
                        <tr>
                            <th>{t}Id{/t}</th>
                            <th>{t}Nom{/t}</th>
                            <th>{t}Projet{/t}</th>
                            <th class="center">
                                <input type="checkbox" id="export" class="checkSelect" checked>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $data as $row}
                            <tr>
                                <td class="center">{$row["campaign_id"]}</td>
                                <td>
                                    <a href="campaignDisplay&campaign_id={$row["campaign_id"]}">
                                        {$row["campaign_name"]}
                                </a>
                                </td>
                                <td>
                                    {$row["project_name"]}
                                </td>
                                <td class="center">
                                    <input type="checkbox" id="export{$row.campaign_id}" name="keys[]" value={$row.campaign_id} class="check" checked>
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            {/if}
        </div>
    </div>
    <div class="row  col-md-6">
        <div class="form-horizontal protoform">
            <div class="form-group">
                <label for="export_model_name1" class="control-label col-md-4">
                    {t}Modèle d'export :{/t}
                </label>
                <div class="col-md-8">
                    <select name="export_model_name" id="export_model_name1" class="form-control">
                        <option value="campaign">{t}Campagnes avec les opérations associées{/t}</option>
                        <option value="campaignOnly">{t}Descriptions des campagnes{/t}</option>
                    </select>
                </div>
            </div>
            <div class="form-group center">
                <button id="exportButton" type="submit" class="btn btn-info">
                    {t}Exporter les campagnes{/t}
                </button>
            </div>
        </div>
    </div>
{$csrf}</form>
<div class="row"></div>
{if $rights.manage == 1}
    <div class="row">
        <fieldset class="col-md-6">
            <legend>{t}Importation de campagnes précédemment exportées{/t}</legend>
            <form class="form-horizontal protoform" id="importExecForm" method="post" action="index.php"
            enctype="multipart/form-data">
                <input type="hidden" name="moduleBase" value="export">
                <input type="hidden" name="action" value="ImportExec">
                <input type="hidden" name="project_id" value="{$searchCampaign.project_id}">
                <input type="hidden" name="returnko" value="campaignList">
                <input type="hidden" name="returnok" value="campaignList">
                <input type="hidden" name="parentKey" value="{$searchCampaign.project_id}">
                <input type="hidden" name="parentKeyName" value="project_id">
                <div class="form-group">
                    <label for="FileName" class="control-label col-md-4">
                        <span class="red">*</span> {t}Fichier à importer (format JSON généré par l'opération d'export ci-dessus) :{/t}
                    </label>
                    <div class="col-md-8">
                        <input id="FileName" type="file" class="form-control" name="filename" size="40" required>
                    </div>
                </div>
                <div class="form-group">
                        <label for="export_model_name2" class="control-label col-md-4">
                            {t}Modèle d'export :{/t}
                        </label>
                        <div class="col-md-8">
                            <select name="export_model_name" id="export_model_name2" class="form-control">
                                <option value="campaign">{t}Campagnes avec les opérations associées{/t}</option>
                                <option value="campaignOnly">{t}Descriptions des campagnes{/t}</option>
                            </select>
                        </div>
                    </div>
                <div class="form-group center">
                    <button id="importButton" type="submit" class="btn btn-warning">{t}Importer une ou plusieurs campagnes{/t}</button>
                </div>
            {$csrf}</form>
        </fieldset>
    </div>
{/if}
