<h2>{t}Liste des campagnes{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {include file="gestion/campaignSearch.tpl" }
    </div>
</div>
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
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        {/if}  
    </div>  
</div>
