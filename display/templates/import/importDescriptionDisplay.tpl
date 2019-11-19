<h2>{t}Détail du modèle d'import{/t} {$data.import_description_id}-{$data.import_description_name}</h2>
<div class="row">
    <a href="index.php?module=importDescriptionList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    {if $droits.param == 1}
        &nbsp;
        <a href="index.php?module=importDescriptionChange&import_description_id={$data.import_description_id}">
            <img src="display/images/edit.gif" height="25">
            {t}Modifier{/t}
        </a>
    {/if}
</div>
<div class="row">
    <div class="col-md-12 col-lg-8 form-display">
        <dl class="dl-horizontal">
            <dt>{t}Type d'import :{/t}</dt>
            <dd>{$data.import_type_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Nom :{/t}</dt>
            <dd>{$data.import_description_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Format du fichier CSV :{/t}</dt>
            <dd>{$data.csv_type_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Séparateur utilisé :{/t}</dt>
            <dd>{$data.separator}</dd>
        </dl>
    </div>
</div>
<div class="row">
    <fieldset class="col-md-12 col-lg-6">
        <legend>{t}Liste des contrôles et mises en formes réalisés pour chaque ligne à traiter{/t}</legend>
        {if $droits.param == 1}
            <a href="index.php?module=importFunctionChange&import_description_id={$data.import_description_id}&import_function_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouvelle fonction à exécuter{/t}
            </a>
        {/if}
        <table class="table table-bordered table-hover datatable-nopaging" data-order='[[3,"asc"]]'>
            <thead>
                <tr>
                    <th>{t}Nom de la fonction{/t}</th>
                    <th>{t}N° de la colonne concernée{/t}</th>
                    <th>{t}Argument associé{/t}</th>
                    <th>{t}Ordre d'exécution{/t}</th>
                    <th>{t}N° de la colonne récupérant le résultat{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $functions as $function}
                    <tr>
                        <td>
                            <a href="index.php?module=importFunctionChange&import_description_id={$function.import_description_id}&import_function_id={$function.import_function_id}">
                                {$function.function_name}
                            </a>
                        </td>
                        <td class="center">
                            {$function.column_number}
                        </td>
                        <td>
                            {$function.arguments}
                        </td>
                        <td class="center">
                            {$function.execution_order}
                        </td>
                        <td class="center">
                            {$function.column_result}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </fieldset>

    <fieldset class="col-md-12 col-lg-6">
        <legend>{t}Table d'équivalence entre les colonnes et la table de la base de données{/t}</legend>
        {if $droits.param == 1}
            <a href="index.php?module=importColumnChange&import_description_id={$data.import_description_id}&import_column_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouvelle colonne{/t}
            </a>
        {/if}
        <table class="table table-bordered table-hover datatable-nopaging" data-order='[[0,"asc"]]'>
            <thead>
                <tr>
                    <th>{t}N° de la colonne{/t}</th>
                    <th>{t}Nom de la colonne dans la table{/t}</th>
                    <th>{t}Clé dans une structure entité-relation ?{/t}</th>
                    <th>{t}Valeur dans une structure entité-relation ?{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $columns as $column}
                    <tr>
                        <td class="center">
                            <a href="index.php?module=importColumnChange&import_description_id={$column.import_description_id}&import_column_id={$column.import_column_id}">
                                {$column.column_order}
                            </a>
                        </td>
                        <td>{$column.table_column_name}</td>
                        <td class="center">{if $column.is_er == 1}{t}oui{/t}{/if}</td>
                        <td class="center">{if $column.is_value == 1}{t}oui{/t}{/if}</td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </fieldset>
</div>