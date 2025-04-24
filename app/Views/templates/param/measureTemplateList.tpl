<h2>{t}Liste des modèles de mesures complémentaires{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {if $rights.param == 1}
            <a href="measureTemplateChange&measure_template_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="paramList" class="table table-bordered table-hover datatable-nopaging display" data-order='[["1","asc"]]'>
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Taxon{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $data as $row}
                    <tr>
                        <td class="center">{$row["measure_template_id"]}</td>
                        <td>
                            {if $rights.param == 1}
                                <a href="measureTemplateChange&measure_template_id={$row.measure_template_id}">
                                {$row["measure_template_name"]}
                            {else}
                                {$row["measure_template_name"]}
                            {/if}
                        </td>
                        <td>{$row.scientific_name}</td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>