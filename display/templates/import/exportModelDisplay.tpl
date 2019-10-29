<h2>{t}Détail du modèle d'exportation{/t} <i>{$data.export_model_name}</i></h2>
<div class="row">
    <a href="index.php?module=exportModelList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    {if $droits.param == 1}
        &nbsp;
        <a href="index.php?module=exportModelChange&export_model_id={$data.export_model_id}">
            <img src="display/images/edit.gif" height="25">
            {t}Modifier{/t}
        </a>
    {/if}
</div>
<div class="row">
    <div class="col-lg-6 col-md-12">
    <table id="patternList" class="table table-bordered table-hover datatable-nosort"  >
        <thead>
            <tr>
                <th>{t}Table{/t}</th>
                <th>{t}Alias{/t}</th>
                <th>{t}Clé primaire{/t}</th>
                <th>{t}Clé métier{/t}</th>
                <th>{t}Clé étrangère{/t}</th>
                <th>{t}Tables liées (alias){/t}</th>
            </tr>
        </thead>
        <tbody>
            {foreach $pattern as $row}
                <tr>
                    <td>{$row.tableName}</td>
                    <td>{$row.tableAlias}</td>
                    <td class="center">{$row.technicalKey}</td>
                    <td class="center">{$row.businessKey}</td>
                    <td class="center">{$row.parentKey}</td>
                    <td>
                        {foreach $row.children as $key=>$child}
                            {if $key > 0}<br>{/if}
                            {$child}
                        {/foreach}
                    </td>
                </tr>
            {/foreach}
        </tbody>
    </table>
    </div>
</div>
