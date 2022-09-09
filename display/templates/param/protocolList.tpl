<h2>{t}Liste des protocoles{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.gestion == 1}
<a href="index.php?module=protocolChange&protocol_id=0">
<img src="display/images/new.png" height="25">
{t}Nouveau...{/t}
</a>
{/if}
<table id="paramList" class="table table-bordered table-hover datatable " >
    <thead>
        <tr>
            <th>{t}Id{/t}</th>
            <th>{t}Nom du protocole{/t}</th>
            <th>{t}Description{/t}</th>
            <th>{t}URL{/t}</th>
            <th>{t}Fichier de description{/t}</th>
            <th>{t}Unité de mesure par défaut{/t}</th>
            <th>{t}Modèle d'analyse complémentaire{/t}</th>
            <th>{t}Modèle de mesures complémentaires d'ambiance{/t}</th>
        </tr>
    </thead>
    <tbody>
        {foreach $data as $row}
            <tr>
                <td class="center">{$row["protocol_id"]}</td>
                <td>
                    <a href="index.php?module=protocolDisplay&protocol_id={$row["protocol_id"]}">
                    {$row["protocol_name"]}
                </td>
                <td class="textareaDisplay">{$row["protocol_description"]}</td>
                <td>
                    {if !empty($row["protocol_url"])}
                        <a href='{$row["protocol_url"]}' target="_blank"  rel="noopener">{$row["protocol_url"]}</a>
                    {/if}
                </td>
                <td> </td>
                <td>
                   {if $row["measure_default"] == "sl"}{t}Longueur standard{/t}
                    {elseif $row.measure_default == "fl"}{t}Longueur fourche{/t}
                    {elseif $row.measure_default == "tl"}{t}Longueur totale{/t}
                    {/if}
                </td>
                <td>{$row.analysis_template_name}</td>
                <td>{$row.ambience_template_name}</td>
            </tr>
        {/foreach}
    </tbody>
</table>
</div>
</div>
