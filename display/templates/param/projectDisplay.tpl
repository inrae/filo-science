<h2>{t}Détail du projet{/t} <i>{$data.project_id} {$data.project_name}</i></h2>
<a href="index.php?module=projectList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
{if $droits.param == 1}
    &nbsp;
    <a href="index.php?module=projectChange&project_id={$data.project_id}">
        <img src="{$display}/images/edit.gif" height="25">{t}Modifier{/t}
    </a>
{/if}
<div class="row">
    <div class="form-display col-md-6">
        <dl class="dl-horizontal">
            <dt>{t}Groupes autorisés :{/t}</dt>
            <dd>{$data.groupe}</dd>
        </dl>
    </div>
</div>
<div class="row">
    <fieldset class="col-md-6">
            <legend>{t}Liste des documents associés{/t}</legend>
            {include file="gestion/documentList.tpl"}
    </fieldset>
</div>
