<script>
$(document).ready(function() {
 /*   table = $("#paramList").DataTable();
    var settings = table.settings();
    settings.searching = true;
    //table.destroy();
    $("#paramList").DataTable(settings);*/
});
</script>
<h2>{t}Liste des pathologies{/t}</h2>
	<div class="row">
	<div class="col-md-6">
{if $rights.param == 1}
<a href="pathologyChange&pathology_id=0">
<img src="display/images/new.png" height="25">
{t}Nouveau...{/t}
</a>
{/if}
<table id="paramList" class="table table-bordered table-hover datatable-searching " >
    <thead>
        <tr>
            <th>{t}Id{/t}</th>
            <th>{t}Libellé{/t}</th>
            <th>{t}Code{/t}</th>
            <th>{t}Description{/t}</th>
        </tr>
    </thead>
    <tbody>
        {foreach $data as $row}
            <tr>
                <td class="center">{$row["pathology_id"]}</td>
                <td>
                    {if $rights.param == 1}
                    <a href="pathologyChange&pathology_id={$row["pathology_id"]}">
                    {$row["pathology_name"]}
                    {else}
                    {$row["pathology_name"]}
                    {/if}
                </td>
                <td>
                    {$row["pathology_code"]}
                </td>
                <td class="textareaDisplay">{$row["pathology_description"]}</td>
            </tr>
        {/foreach}
    </tbody>
</table>
</div>
</div>