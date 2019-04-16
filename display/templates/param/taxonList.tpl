<h2>{t}Liste des taxons{/t}</h2>
	<div class="row">
	<div class="col-md-12">
{if $droits.param == 1}
<a href="index.php?module=taxonChange&taxon_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="paramList" class="table table-bordered table-hover datatable-searching " data-order='[[1,"asc"]]'>
    <thead>
        <tr>
            <th>{t}Id{/t}</th>
            <th>{t}Nom scientifique{/t}</th>
            <th>{t}Nom commun{/t}</th>
            <th>{t}Code Sandre{/t}</th>
            <th>{t}Code rivière{/t}</th>
            <th>{t}Code mer/estuaire{/t}</th>
            <th>{t}Écotype{/t}</th>
            <th>{t}Longueur max (cm){/t}</th>
            <th>{t}Poids max (g){/t}</th>
        </tr>
    </thead>
    <tbody>
        {foreach $data as $row}
            <tr>
                <td class="center">{$row["taxon_id"]}</td>
                <td>
                    {if $droits.param == 1}
                    <a href="index.php?module=taxonChange&taxon_id={$row["taxon_id"]}">
                    {$row["scientific_name"]}
                    </a>
                    {else}
                    {$row["taxon_name"]} 
                    {/if}
                    {if strlen($row["author"])>0}&nbsp;({$row["author"]}){/if}
                </td>
                <td>
                    {$row["common_name"]}
                </td>
                <td class="center">{$row["taxon_code"]}</td>
                <td class="center">{$row["fresh_code"]}</td>
                <td class="center">{$row["sea_code"]}</td>
                <td class="center">{$row["ecotype"]}</td>
                <td class="center">{$row["length_max"]}</td>
                <td class="center">{$row["weight_max"]}</td>
            </tr>
        {/foreach}
    </tbody>
</table>
</div>
</div>