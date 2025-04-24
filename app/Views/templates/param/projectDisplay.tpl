<h2>{t}Détail du projet{/t} <i>{$data.project_id} {$data.project_name}</i></h2>
<a href="projectList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
{if $rights.param == 1}
    &nbsp;
    <a href="projectChange&project_id={$data.project_id}">
        <img src="display/images/edit.gif" height="25">{t}Modifier{/t}
    </a>
{/if}
<div class="row">
    <div class="form-display col-md-6">
        <dl class="dl-horizontal">
            <dt>{t}Groupes autorisés :{/t}</dt>
            <dd>{$data.groupe}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Projet actif ?{/t}</dt>
            <dd>{if $data.is_active == 1}{t}oui{/t}{else}{t}non{/t}{/if}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Protocole utilisé par défaut :{/t}</dt>
            <dd>{$data.protocol_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Projection (SRID) utilisée pour convertir les coordonnées géographiques en système cartésien :{/t}</dt>
            <dd>{$data.metric_srid}</dd>
        </dl>
    </div>
</div>
<div class="row">
    <fieldset class="col-md-6">
            <legend>{t}Liste des documents associés{/t}</legend>
            {include file="gestion/documentList.tpl"}
    </fieldset>
</div>
