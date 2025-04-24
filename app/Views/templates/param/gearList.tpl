<h2>{t}Liste des engins de pêche{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $rights.param == 1}
<a href="gearChange&gear_id=0">
<img src="display/images/new.png" height="25">
{t}Nouveau...{/t}
</a>
{/if}
<table id="paramList" class="table table-bordered table-hover datatable-searching " >
    <thead>
        <tr>
            <th>{t}Id{/t}</th>
            <th>{t}Nom{/t}</th>
            <th>{t}Longueur (mètres){/t}</th>
            <th>{t}Hauteur (mètres){/t}</th>
            <th>{t}Taille de la maille{/t}</th>
        </tr>
    </thead>
    <tbody>
        {foreach $data as $row}
            <tr>
                <td class="center">{$row["gear_id"]}</td>
                <td>
                    {if $rights.param == 1}
                    <a href="gearChange&gear_id={$row["gear_id"]}">
                    {$row["gear_name"]}
                    {else}
                    {$row["gear_name"]}
                    {/if}
                </td>
                <td class="center">
                    {$row["gear_length"]}
                </td>
                <td class="center">
                    {$row["gear_height"]}
                </td>
                <td>
                    {$row["mesh_size"]}
                </td>
            </tr>
        {/foreach}
    </tbody>
</table>
</div>
</div>