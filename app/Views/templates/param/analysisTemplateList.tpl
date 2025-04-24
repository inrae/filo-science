<h2>{t}Liste des modèles d'analyse complémentaire{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {if $rights.param == 1}
            <a href="analysisTemplateChange?analysis_template_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="paramList" class="table table-bordered table-hover datatable-nopaging display" >
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Nom{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $data as $row}
                    <tr>
                        <td class="center">{$row["analysis_template_id"]}</td>
                        <td>
                            {if $rights.param == 1}
                                <a href="analysisTemplateChange?analysis_template_id={$row.analysis_template_id}">
                                {$row["analysis_template_name"]}
                            {else}
                                {$row["analysis_template_name"]}
                            {/if}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>
