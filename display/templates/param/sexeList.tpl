<h2>{t}Liste des sexes{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $droits.param == 1}
<img src="display/images/new.png" height="25">
<a href="index.php?module=sexeChange&sexe_id=0">
{t}Nouveau...{/t}
</a>
{/if}
<table id="paramList" class="table table-bordered table-hover datatable " >
    <thead>
        <tr>
            <th>{t}Id{/t}</th>
            <th>{t}Libellé{/t}</th>
            <th>{t}Code{/t}</th>
        </tr>
    </thead>
    <tbody>
        {foreach $data as $row}
            <tr>
                <td class="center">{$row["sexe_id"]}</td>
                <td>
                    {if $droits.param == 1}
                    <a href='index.php?module=sexeChange&sexe_id={$row["sexe_id"]}'>
                    {$row["sexe_name"]}
                    {else}
                    {$row["sexe_name"]}
                    {/if}
                </td>
                <td>
                    {$row["sexe_code"]}
                </td>
            </tr>
        {/foreach}
    </tbody>
</table>
</div>
</div>