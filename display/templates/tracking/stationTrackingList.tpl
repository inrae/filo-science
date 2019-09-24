<script>
    $(document).ready(function () {
        var projectId = "{$projects[0].project_id}";
        try {
            var projectIdCookie= Cookies.get("projectId");
        } catch { 
            Cookies.set("projectId", projectId, { expires: 180, secure: true });
        }
        if (projectIdCookie != '') {
            projectId = projectIdCookie;
        } else {
            Cookies.set("projectId", projectId, { expires: 180, secure: true });
        }
        var projectActive = 1;
        try {
            projectActive = Cookies.get("projectActive");
        } catch { }
        $("#projectActive" + projectActive).attr("checked", "true");
        $("#project"+projectId).attr("selected", true);
        $(".is_active").change(function () {
            $("#project_id").val("");
            Cookies.set("projectId", '', { expires: 180, secure: true });
            Cookies.set("projectActive", $(this).val(), { expires: 180, secure: true });
            $("#stationTrackingSearch").submit();
        });
        $("#project_id").change(function () {
            Cookies.set("projectId", $(this).val(), { expires: 180, secure: true });
            $("#stationTrackingSearch").submit();
        });


    });
</script>
<h2>{t}Liste des stations utilisées pour la télédétection{/t}</h2>
<div class="row">
    <form class="form-horizontal protoform" id="stationTrackingSearch" action="index.php" method="GET">
        <input id="module" type="hidden" name="module" value="stationTrackingList">
        <input id="isSearch" type="hidden" name="isSearch" value="1">
        <div class="form-group">
            <label for="project_id" class="col-md-2 control-label">{t}Projet :{/t}</label>
            <div class="col-md-4">
                <select id="project_id" name="project_id" class="form-control">
                    {foreach $projects as $row}
                    <option id="project{$row.project_id}" value="{$row.project_id}">
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
                <input type="radio" class="is_active" id="projectActive1" name="is_active" value="1">{t}oui{/t}
                <input type="radio" class="is_active" id="projectActive0" name="is_active" value="0">{t}non{/t}
            </div>
        </div>

    </form>
</div>
<div class="row">
    <div class="col-md-12">
        {if $droits.gestion == 1}
            <a href="index.php?module=stationTrackingChange&station_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="stationList" class="table table-bordered table-hover datatable-nopaging " >
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Type de station{/t}</th>
                    <th>{t}Code métier{/t}</th>
                    <th>{t}Cours d'eau{/t}</th>
                    <th>{t}Projet{/t}</th>
                    <th>{t}Longitude{/t}</th>
                    <th>{t}Latitude{/t}</th>
                    <th>{t}PK{/t}</th>
                    {if $droits.gestion == 1}
                        <th class="center">
                            <img src="display/images/edit.gif" height="25" title="{t}Modifier{/t}">
                        </th>
                    {/if}
                </tr>
            </thead>
            <tbody>
                {foreach $stations as $station}
                    <tr>
                        <td>{$station.station_id}</td>
                        <td>
                            {if $droits.gestion == 1}
                                <a href="index.php?module=stationTrackingDisplay&station_id={$station.station_id}">
                                {$station.station_name}
                            </a>
                            {else}
                                {$station.station_name}
                            {/if}
                        </td>
                        <td>{$station.station_type_name}</td>
                        <td>{$station.station_code}</td>
                        <td>{$station.river_name}</td>
                        <td>{$station.project_name}</td>
                        <td>{$station.station_long}</td>
                        <td>{$station.station_lat}</td>
                        <td>{$station.station_pk}</td>
                        {if $droits.gestion == 1}
                            <td class="center">
                                <a href="index.php?module=stationTrackingChange&station_id={$station.station_id}" title="{t}Modifier{/t}">
                                    <img src="display/images/edit.gif" height="25">
                                </a>
                            </td>
                        {/if}
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>