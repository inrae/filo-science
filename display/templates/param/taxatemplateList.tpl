<h2>{t}Modèles de sélection de taxons{/t}</h2>
<div class="row">
	<div class="col-md-6">
        {if $droits.gestion == 1}
            <a href="index.php?module=taxatemplateChange&taxa_template_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="taxatemplateList" class="table table-bordered table-hover datatable " data-order='[[0,"asc"]]' >
            <thead>
                <tr>
                    <th>{t}Nom du modèle{/th}</th>
                    <th>{t}Type de milieu{/th}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $data as $line}
                    <tr>
                        <td>
                            {if $droits.gestion == 1}
                                <a href="index.php?module=taxatemplateChange&taxa_template_id={$line.taxa_template_id}">
                                    {$line.taxa_template_name}
                                </a>
                            {else}
                                {$line.taxa_template_name}
                            {/if}
                        </td>
                        <td>
                            {if $line.freshwater == 1}
                                {t}Eau douce{/t}
                            {else}
                                {t}Eau de mer{/t}
                            {/if}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>
