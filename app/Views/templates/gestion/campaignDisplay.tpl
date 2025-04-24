<script>
    $(document).ready(function() {
        Cookies.set('campaign_uid', "{$data.campaign_uid}", { expires: 7, secure: true });
        $(".checkSelect").change(function() {
            $('.check').prop('checked', this.checked);
        });
    });
</script>
<h2>{t}Détail d'une campagne{/t}</h2>
<div class="row">
    <div class="col-md-12">
        <a href="campaignList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
        {if $rights.manage == 1}
        &nbsp;
        <a href="campaignChange?campaign_id=0">
            <img src="display/images/new.png" height="25">
            {t}Nouvelle campagne{/t}
        </a>
        &nbsp;
        <a href="campaignChange?campaign_id={$data.campaign_id}">
            <img src="display/images/edit.gif" height="25">{t}Modifier{/t}
        </a>
        {/if}
    </div>
</div>

<div class="row">
    <fieldset class="col-md-6">
        <legend>{t}Informations générales{/t}</legend>
        <div class="form-display">
            <dl class="dl-horizontal">
                <dt>{t}Nom de la campagne :{/t}</dt>
                <dd>{$data.campaign_name}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Projet :{/t}</dt>
                <dd>{$data.project_name}</dd>
            </dl>
        </div>
    </fieldset>
</div>
<div class="row">
    <fieldset class="col-md-12">
        <legend>Opérations réalisées</legend>
        {if $rights.manage == 1}
        <div class="row">
            <div class="col-md-2">
                <img src="display/images/new.png" height="25">
        <a href="operationChange?operation_id=0&campaign_id={$data.campaign_id}">
            {t}Nouvelle opération...{/t}
        </a>
            </div>
            <div class="col-md-2 col-md-offset-8">
                <img src="display/images/fish.png" height="25">
                <a href="individualGetListFromCampaign&campaign_id={$data.campaign_id}">
                    {t}Exporter les poissons mesurés{/t}
                </a>
            </div>
        </div>

        {/if}
        <form id="exportForm" method="post" action="exportExec">
            <input type="hidden" name="moduleBase" value="export">
            <input type="hidden" name="export_model_name" value="operation">
            <input type="hidden" name="returnko" value="campaignDisplay">
            <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
            <input type="hidden" name="translator" value="ti_operation">
            <table class="datatable table table-bordered table-hover" data-order='[[1,"desc"]]'>
                <thead>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Date/heure de début{/t}</th>
                    <th>{t}Station{/t}</th>
                    <th>{t}Protocole{/t}</th>
                    <th>{t}Stratégie de pêche{/t}</th>
                    <th>{t}Échelle{/t}</th>
                    <th>{t}Modèle de saisie{/t}</th>
                    <th class="center">
                        <input type="checkbox" id="export" class="checkSelect" checked>
                    </th>
                </thead>
                <tbody>
                    {foreach $operations as $row}
                        <tr>
                            <td>
                                <a href="operationDisplay?operation_id={$row.operation_id}&campaign_id={$data.campaign_id}">
                                    {$row.operation_name}
                                </a>

                            </td>
                            <td>{$row.date_start}</td>
                            <td>{$row.station_name}</td>
                            <td>{$row.protocol_name}</td>
                            <td>{$row.fishing_strategy_name}</td>
                            <td>{$row.scale_name}</td>
                            <td>{$row.taxa_template_name}</td>
                            <td class="center">
                                <input type="checkbox" id="export{$row.operation_id}" name="keys[]" value={$row.operation_id} class="check" checked>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
            <div class="row">
                <div class="col-md-6">
                    {if $rights.manage == 1}
                        <button id="exportButton" type="submit" class="btn btn-info">{t}Exporter les opérations sélectionnées{/t}</button>
                    {/if}
                </div>
            </div>
        {$csrf}</form>
    </fieldset>
</div>
{if $rights.manage == 1}
    <div class="row">
        <form class="form-horizontal  col-md-6" id="importExecForm" method="post" action="exportImportExec"
        enctype="multipart/form-data">
            <input type="hidden" name="moduleBase" value="export">
            <input type="hidden" name="export_model_name" value="operation">
            <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
            <input type="hidden" name="returnko" value="campaignDisplay">
            <input type="hidden" name="returnok" value="campaignDisplay">
            <input type="hidden" name="parentKey" value="{$data.campaign_id}">
            <input type="hidden" name="parentKeyName" value="campaign_id">
            <input type="hidden" name="translator" value="ti_campaign">
            <div class="form-group">
                <label for="FileName" class="control-label col-md-4">
                    <span class="red">*</span> {t}Fichier à importer (format JSON généré par l'opération d'export ci-dessus) :{/t}
                </label>
                <div class="col-md-8">
                    <input id="FileName" type="file" class="form-control" name="filename" size="40" required>
                </div>
            </div>
            <div class="form-group center">
                <button id="importButton" type="submit" class="btn btn-warning">{t}Importer une ou plusieurs opérations{/t}</button>
            </div>
        {$csrf}</form>
    </div>
{/if}
