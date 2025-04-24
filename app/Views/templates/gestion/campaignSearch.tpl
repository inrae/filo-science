<script>
$(document).ready(function(){ 
    $(".is_active").change(function () { 
        $("#project_id").val("");
        $("#campaignSearch").submit();
    });
});
</script>
<div class="row">
    <form class="form-horizontal " id="campaignSearch" action="campaignList" method="GET">
        <input id="isSearch" type="hidden" name="isSearch" value="1">
        <div class="form-group">
            <label for="project_id" class="col-md-2 control-label">{t}Projet :{/t}</label>
            <div class="col-md-4">
                <select id="project_id" name="project_id" class="form-control">
                    {foreach $projects as $row}
                        <option value="{$row.project_id}" {if $row.project_id == $searchCampaign.project_id}selected{/if}>
                        {$row.project_name}
                        </option>
                    {/foreach}
                </select>
            </div>
            <div class="col-md-2 col-md-offset-3">
                <input type="submit" class="btn btn-success" value="{t}Rechercher{/t}">
            </div>   
        </div>
        <div class="form-group">
            <label for="is_active" class="col-md-2 control-label">{t}Projets actifs :{/t}</label>
            <div class="col-md-4">
                <input type="radio" class="is_active" name="is_active" value="1" {if $searchCampaign.is_active == 1}checked{/if}>{t}oui{/t}
                <input type="radio" class="is_active" name="is_active" value="0" {if $searchCampaign.is_active == 0}checked{/if}>{t}non{/t}
            </div>
        </div>
        
    {$csrf}</form>
</div>