<h2>{t}Liste des modèles d'import{/t}</h2>
{if $droits.param == 1}
    <a href="index.php?module=importDescriptionChange&import_description_id=0">
        <img src="display/images/new.png" height="25">
        {t}Nouveau modèle{/t}
    </a>
{/if}
<div class="row">
    <div class="col-md-6">
        <table id="stationList" class="table table-bordered table-hover datatable-nopaging " >
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Type{/t}</th>
                    <th>{t}Format du fichier CSV{/t}</th>
                    <th>{t}Séparateur{/t}</th>
                    {if $droits.param == 1}
                        <th>{t}Modifier{/t}</th>
                        <th>{t}Dupliquer{/t}</th>
                    {/if}
                </tr>
            </thead>
            <tbody>
                {foreach $imports as $import}
                    <tr>
                        <td class="center">{$import.import_description_id}</td>
                        <td>
                            <a href="index.php?module=importDescriptionDisplay&import_description_id={$import.import_description_id}" title="{t}Afficher le détail{/t}">
                                {$import.import_description_name}
                            </a>
                        </td>
                        <td>{$import.import_type_name}</td>
                        <td>{$import.csv_type_name}</td>
                        <td class="center">{$import.separator}</td>
                        {if $droits.param == 1}
                            <td class="center">
                                <a href="index.php?module=importDescriptionChange&import_description_id={$import.import_description_id}">
                                    <img src="display/images/edit.gif" height="25" title="{t}Modifier{/t}">
                                </a>
                            </td>
                            <td class="center">
                                <a href="index.php?module=importDescriptionDuplicate&import_description_id={$import.import_description_id}">
                                        <img src="display/images/copy.png" height="25" title="{t}Dupliquer{/t}">
                                </a>
                            </td>
                        {/if}
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>