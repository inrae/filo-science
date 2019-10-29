<h2>{t}Liste des modèles d'exportation des données{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {if $droits.param == 1}
            <a href="index.php?module=exportModelChange&export_model_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="paramList" class="table table-bordered table-hover datatable-nopaging" data-order='[["1","asc"]]'>
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Nom{/t}</th>
                    {if $droits.param == 1}
                        <th>{t}Modifier{/t}</th>
                    {/if}
                </tr>
            </thead>
            <tbody>
                {foreach $data as $row}
                    <tr>
                        <td class="center">{$row["export_model_id"]}</td>
                        <td>
                            {if $droits.param == 1}
                                <a href="index.php?module=exportModelDisplay&export_model_id={$row.export_model_id}">
                                {$row["export_model_name"]}
                            {else}
                                {$row["export_model_name"]}
                            {/if}
                        </td>
                        {if $droits.param == 1}
                            <td class="center">
                                <a href="index.php?module=exportModelChange&export_model_id={$row.export_model_id}">
                                    <img src="display/images/edit.gif" height="25">
                                </a>
                            </td>
                        {/if}
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>