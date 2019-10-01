<h2>{t}Détail du modèle d'import{/t} {$data.import_description_id}-{$data.import_description_name}</h2>
<div class="row">
    <a href="index.php?module=importDescriptionList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    <div class="col-md-6 form-display">
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
    <fieldset class="col-md-6">
        <legend>{t}Liste des contrôles et mises en formes réalisés pour chaque ligne à traiter{/t}</legend>
        {if $droits.param == 1}
            <a href="index.php?module="importFunctionChange&import_description_id={$data.import_description_id}&import_function_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouvelle fonction à exécuter{/t}
            </a>
        {/if}
        <table class="table table-bordered table-hover datatable-nopaging" data-order='[[3,"asc"]]'>
            <head>
                <tr>
                    <th>{t}Nom de la fonction{/t}</th>
                    <th>{t}Numéro de la colonne concernée{/t}</th>
                    <th>{t}Argument associé{/t}</th>
                    <th>{t}Ordre d'exécution{/t}</th>
                </tr>
            </head>
            <tbody>
                {foreach $functions as $function}
                    <tr>
                        <td>
                            <a href="index.php?module=importFunctionChange&import_description_id={$function.import_description_id}&import_function_id={$function.import_function_id}">
                                {$function.function_name}
                            </a>
                        </td>
                        <td class="center">
                            {$import.column_number}
                        </td>
                        <td>
                            {$import.arguments}
                        </td>
                        <td class="center">
                            {$import.execution_order}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </fieldset>
</div>
<div class="row">
    <fieldset class="col-md-6">
        <legend>{t}Table d'équivalence entre les colonnes et la table de la base de données{/t}</legend>
    </fieldset>
</div>