<h2>{t}Détail d'une campagne{/t}</h2>
<div class="row">
    <div class="col-md-12">
        <a href="index.php?module=campaignList"><img src="display/images/list.png" height="25">{t}Retour à la
            liste{/t}</a>
        {if $droits.gestion == 1}
        &nbsp;
        <a href="index.php?module=campaignChange&campaign_id=0">
            <img src="{$display}/images/new.png" height="25">
            {t}Nouvelle campagne{/t}
        </a>
        &nbsp;
        <a href="index.php?module=campaignChange&campaign_id={$data.campaign_id}">
            <img src="{$display}/images/edit.gif" height="25">{t}Modifier{/t}
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
        {if $droits.gestion == 1}
        <img src="display/images/new.png" height="25">
        <a href="index.php?module=operationChange&operation_id=0">
            {t}Nouveau...{/t}
        </a>
        {/if}
        <table class="datatable table table-bordered table-hover" data-order='[[1,"desc"]]'>
            <thead>
                <th>{t}Nom{/t}</th>
                <th>{t}Date/heure de début{/t}</th>
                <th>{t}Station{/t}</th>
                <th>{t}Protocole{/t}</th>
                <th>{t}Stratégie de pêche{/t}</th>
                <th>{t}Échelle{/t}</th>
                <th>{t}Modèle de saisie{/t}</th>
            </thead>
            <tbody>
                {foreach $operations as $row}
                <td>
                    {if $droits.gestion == 1}
                    <a href="index.php?module=operationChange&operation_id={$row.operation_id}">
                        {$row.operation_name}
                    </a>
                    {else}
                    {$row.operation_name}
                    {/if}
                </td>
                <td>{$row.date_start}</td>
                <td>{$row.station_name}</td>
                <td>{$row.protocol_name}</td>
                <td>{$row.fishing_strategy_name}</td>
                <td>{$row.scale_name}</td>
                <td>{$row.taxa_template_name}</td>
                {/foreach}
            </tbody>
        </table>
    </fieldset>

</div>