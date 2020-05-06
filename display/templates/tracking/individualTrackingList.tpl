<script>
    $(document).ready(function () {
        var projectId = "{$projects[0].project_id}";
        console.log("projectId:"+projectId);
        try {
            var projectIdCookie = Cookies.get("projectId");
        } catch {
            Cookies.set("projectId", projectId, { expires: 180, secure: true });
        }
        if (projectIdCookie != '' && projectIdCookie != undefined) {
            projectId = projectIdCookie;
        } else {
            Cookies.set("projectId", projectId, { expires: 180, secure: true });
        }
        var projectActive = 1;
        try {
            projectActive = Cookies.get("projectActive");
        } catch { }
        $("#projectActive" + projectActive).attr("checked", "true");
        $("#project" + projectId).attr("selected", true);
        console.log("projectId:"+projectId);
        $("#new").attr("href", "index.php?module=individualTrackingChange&individual_id=0&project_id="+projectId);
        $(".is_active").change(function () {
            $("#project_id").val("");
            Cookies.set("projectId", '', { expires: 180, secure: true });
            Cookies.set("projectActive", $(this).val(), { expires: 180, secure: true });
            $("#individualTrackingSearch").submit();
        });
        $("#project_id").change(function () {
            Cookies.set("projectId", $(this).val(), { expires: 180, secure: true });
            $("#individualTrackingSearch").submit();
        });
        $("#checkId").change(function(){
            $(".checkId").prop('checked', this.checked);
        });
        $("#exportDetection").on ("keypress click", function(event) {
            $("#module").val("individualTrackingExport");
            $(this.form).prop('target', '_self').submit();
        });
    });
</script>
<h2>{t}Liste des poissons suivis{/t}</h2>
<div class="row">
    {if $droits.gestion == 1}
        <a id="new" href="index.php?module=individualTrackingChange&individual_id=0">
            <img src="display/images/new.png" height="25">
            {t}Nouveau...{/t}
        </a>
    {/if}
</div>
<div class="row">
    <div class="col-lg-6 col-md-12">
        <form class="form-horizontal protoform" id="individualTrackingSearch" action="index.php" method="GET">
            <input id="moduleSearch" type="hidden" name="module" value="individualTrackingList">
            <input id="isSearch" type="hidden" name="isSearch" value="1">
            <div class="form-group">
                <label for="project_id" class="col-md-2 control-label">{t}Projet :{/t}</label>
                <div class="col-md-4">
                    <select id="project_id" name="project_id" class="form-control">
                        {foreach $projects as $row}
                        <option id="project{$row.project_id}" value="{$row.project_id}" {if $row.project_id == $project_id}selected{/if}>
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
                    <input type="radio" class="is_active" id="projectActive1" name="is_active" value="1" {if $is_active == 1}checked{/if}>{t}oui{/t}
                    <input type="radio" class="is_active" id="projectActive0" name="is_active" value="0"{if $is_active == 0}checked{/if}>{t}non{/t}
                </div>
            </div>
        </form>
    </div>
</div>
<div class="row">
    <div class="col-md-12 col-lg-8">
        <form id="findividualList" method="POST" action="index.php">
            <input type="hidden" name="module" id="module" value="individualTrackingList">
            <input type="hidden" name="project_id" value="{$project_id}">
            <div class="row">
                <button id="exportDetection" class="btn btn-info">{t}Exporter les détections{/t}</button>
            </div>
            <table id="individualList" class="table table-bordered table-hover datatable " data-order = '[[1,"asc"]]'>
                <thead>
                    <tr>
                        <th class="center">
                            <input type="checkbox" id="checkId" class="checkId" checked>
                        </th>
                        <th>{t}Id{/t}</th>
                        <th>{t}Taxon{/t}</th>
                        <th>{t}Tag RFID{/t}</th>
                        <th>{t}Émetteur acoustique ou radio{/t}</th>
                        <th>{t}Modèle d'émetteur{/t}</th>
                        <th>{t}Identifiant unique{/t}</th>
                        <th>{t}Détections{/t}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $individuals as $individual}
                    <tr>
                        <td class="center">
                            <input type="checkbox" class="checkId" name="uids[]" value="{$individual.individual_id}" checked>
                        </td>
                        <td class="center {if $individual.individual_id == $selectedIndividual}itemSelected{/if}">
                            {if $droits.gestion == 1}
                                <a href="index.php?module=individualTrackingChange&individual_id={$individual.individual_id}&project_id={$individual.project_id}"
                                    title="{t}Modifier{/t}">
                                    {$individual.individual_id}
                                </a>
                            {else}
                                {$individual.individual_id}
                            {/if}
                        </td>
                        <td>{$individual.scientific_name}</td>
                        <td>{$individual.tag}</td>
                        <td>{$individual.transmitter}</td>
                        <td>{$individual.transmitter_type_name}</td>
                        <td>{$individual.uuid}</td>
                        <td class="center">
                                <a href="index.php?module=individualTrackingList&individual_id={$individual.individual_id}">
                                        <img src="display/images/result.png" height="25">
                                    </a>
                        </td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </form>
    </div>
    {if $selectedIndividual > 0}
    <div class="col-md-12 col-lg-4">
        {include file="tracking/individualTrackingMap.tpl"}
    </div>
        <fieldset class="col-lg-12">
            <legend>{t}Liste des détections{/t}</legend>
            <a href="index.php?module=locationChange&location_id=0&individual_id={$selectedIndividual}">
                {t}Nouvelle détection manuelle{/t}
            </a>
            {if count($detections) > 0}
                <table id="detectionList" class="table table-bordered table-hover datatable" data-order='[[ 1,"asc"],[0,"asc"]]'>
                    <thead>
                        <tr>
                            <th>{t}Id{/t}</th>
                            <th>{t}Date/heure de détection{/t}</th>
                            <th>{t}Type de détection{/t}</th>
                            <th>{t}Nbre d'événements{/t}</th>
                            <th>{t}Durée, en secondes{/t}</th>
                            <th>{t}Force du signal{/t}</th>
                            <th>{t}Longitude{/t}</th>
                            <th>{t}Latitude{/t}</th>
                            <th>{t}Observation{/t}</th>
                            <th>{t}Valide ?{/t}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $detections as $detection}
                            <tr>
                                <td class="center">
                                    {if $droits.gestion == 1}
                                        {if $detection.detection_type == "stationary"}
                                            <a href="index.php?module=detectionChange&detection_id={$detection.id}&individual_id={$detection.individual_id}">
                                            {else}
                                            <a href="index.php?module=locationChange&location_id={$detection.id}&individual_id={$detection.individual_id}">
                                        {/if}
                                        {$detection.id}
                                        </a>
                                    {else}
                                        {$detection.id}
                                    {/if}
                                </td>
                                <td>{$detection.detection_date}</td>
                                <td>
                                    {if $detection.detection_type == "stationary"}
                                        {t}Station fixe{/t}
                                    {else}
                                        {t}Détection mobile{/t}
                                    {/if}
                                </td>
                                <td class="center">{$detection.nb_events}</td>
                                <td class="center">{$detection.duration}</td>
                                <td class="right">{$detection.signal_force}</td>
                                <td class="right">{$detection.long}</td>
                                <td class="right">{$detection.lat}</td>
                                <td class="textareaDisplay">{$detection.observation}</td>
                                <td class="center">
                                    {if $detection.validity == 1}{t}oui{/t}{else}<span class="red">{t}non{/t}</span>{/if}
                                </td>
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            {/if}
        </fieldset>
    {/if}
</div>