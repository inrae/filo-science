<h2>{t}Détail d'un protocole{/t}</h2>
<div class="row">
    <div class="col-md-12">
        <a href="index.php?module=protocolList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
        {if $droits.gestion == 1}
            &nbsp;
            <a href="index.php?module=protocolChange&protocol_id=0">
                <img src="{$display}/images/new.png" height="25">
                {t}Nouveau protocole{/t}
            </a>
            &nbsp;
            <a href="index.php?module=protocolChange&protocol_id={$data.protocol_id}">
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
                <dt>{t}Nom du protocole :{/t}</dt>
                <dd>{$data.protocol_name}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Description :{/t}</dt>
                <dd class="textareaDisplay">{$data.protocol_description}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Lien d'accès au protocole :{/t}</dt>
                <dd>
                {if strlen($data.protocol_url)>0}
                    <a href="{$data.protocol_url}" target="_blank">
                        {$data.protocol_url}
                    </a>
                {/if}
                </dd>
            </dl>
            
            <dl class="dl-horizontal">
                <dt>{t}Mesure de longueur réalisée par défaut :{/t}</dt>
                <dd>
                    {if $data["measure_default"] == "sl"}{t}Longueur standard{/t}
                    {elseif $data.measure_default == "fl"}{t}Longueur fourche{/t}
                    {elseif $data.measure_default == "tl"}{t}Longueur totale{/t}
                    {/if} 
                </dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Seule la longueur par défaut est-elle autorisée ?{/t}</dt>
                <dd>{if $data.measure_default_only == 1}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Modèle d'analyse complémentaire :{/t}</dt>
                <dd>{$data.analysis_template_name}</dd>
            </dl>
        </div>
    </fieldset>

    <fieldset class="col-md-6">
    <legend>Modèles de mesure rattachés</legend>

        <table class="datatable table table-bordered table-hover" data-order='[[0,"asc"]]'>
            <thead>
                <th>{t}Taxon{/t}</th>
                <th>{t}Nom du modèle{/t}</th>
            </thead>
            <tbody>
                {foreach $mtdata as $row}
                    <td>
                        {$row["scientific_name"]}
                    </td>
                    <td>
                        {$row["measure_template_name"]}
                    </td>
                {/foreach}
            </tbody>
        </table>
    </fieldset>
</div>
<div class="row">
    <fieldset class="col-md-6">
            <legend>{t}Liste des documents associés{/t}</legend>
            {include file="gestion/documentList.tpl"}
    </fieldset>
</div>