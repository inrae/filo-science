<div class="row">
    <form class="form-horizontal protoform" id="campaignSearch" action="index.php" method="GET">
        <input id="module" type="hidden" name="module" value="campaignList">
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
        
    </form>
</div>