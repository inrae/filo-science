<script>
    $(document).ready(function() {
        $(".checkSelect").change(function() {
            $('.check').prop('checked', this.checked);
        });
    });
</script>
<h2>{t}Liste des campagnes{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {include file="gestion/campaignSearch.tpl" }
    </div>
</div>
<form id="exportForm" method="post" action="index.php">
    <input type="hidden" name="moduleBase" value="export">
    <input type="hidden" name="action" value="Exec">
    <input type="hidden" name="export_model_name" value="campaign">
    <input type="hidden" name="returnko" value="campaignList">
    <input type="hidden" name="translator" value="ti_campaign">

    <div class="row">
        <div class="col-md-6">
            {if $droits.gestion == 1}
                <img src="display/images/new.png" height="25">
                <a href="index.php?module=campaignChange&campaign_id=0">
                    {t}Nouveau...{/t}
                </a>
            {/if}
            {if $isSearch == 1}
                <table id="paramList" class="table table-bordered table-hover datatable " >
                    <thead>
                        <tr>
                            <th>{t}Id{/t}</th>
                            <th>{t}Nom{/t}</th>
                            <th>{t}Projet{/t}</th>
                            <th class="center">
                                <input type="checkbox" id="export" class="checkSelect" checked>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $data as $row}
                            <tr>
                                <td class="center">{$row["campaign_id"]}</td>
                                <td>
                                    <a href="index.php?module=campaignDisplay&campaign_id={$row["campaign_id"]}">
                                        {$row["campaign_name"]}
                                </a>
                                </td>
                                <td>
                                    {$row["project_name"]}
                                </td>
                                <td class="center">
                                    <input type="checkbox" id="export{$row.campaign_id}" name="keys[]" value={$row.campaign_id} class="check" checked>
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            {/if}
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <button id="exportButton" type="submit" class="btn btn-info">{t}Exporter les campagnes avec les opérations associées{/t}</button>
        </div>
    </div>
</form>