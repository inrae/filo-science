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
        $("#project"+projectId).attr("selected", true);
        $("#project_id").change(function () {
            Cookies.set("projectId", $(this).val(), { expires: 180, secure: true });
            $("#stationTrackingSearch").submit();
        });
        $("#import_description_id").change(function () { 
            $.ajax({
                url: "index.php",
                data: { 
                    "module": "stationTrackingGetSensors", 
                    "import_description_id": $(this).val(),
                    "project_id": $("#project_id").val()
                    }
            })
            .done(function (value) {
                var val = JSON.parse(value);
                var options = "";
                val.foreach(function (element) { 
                    options += '<option value="'+ element.sensor_id + '" >' + element.station_name + ' '+element.station_code + ':'+element.sensor_code+'</option>';
                });
                $("#sensor_id").html(options);
            });
        });
        $("#testMode:checkbox").change(function () { 
            $("#nbLines").attr("hidden", ! this.checked);
        });
    });
</script>

<h2>Exécution d'un import</h2>

<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal protoform" id="importForm" method="post" action="index.php"
            enctype="multipart/form-data">
            <input type="hidden" name="module" value="importExec">

            <div class="form-group">
                <label for="FileName" class="control-label col-md-4">
                    <span class="red">*</span> {t}Fichier à importer :{/t}
                </label>
                <div class="col-md-8">
                    <input id="FileName" type="file" class="form-control" name="filename" size="40" required>
                </div>
            </div>
            <div class="form-group">
                <label for="import_description_id" class="control-label col-md-4">
                    <span class="red">*</span> {t}Type d'import à réaliser :{/t}
                </label>
                <div class="col-md-8">
                    <select id="import_description_id" name="import_description_id" class="form-control">
                        {foreach $imports as $import}
                        <option value="{$import.import_description_id}">
                            {$import.import_description_name}
                        </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
            <label for="project_id" class="col-md-2 control-label">{t}Projet :{/t}</label>
            <div class="col-md-4">
                <select id="project_id" name="project_id" class="form-control">
                    {foreach $projects as $project}
                        <option id="project{$project.project_id}" value="{$project.project_id}">
                            {$project.project_name}
                        </option>
                    {/foreach}
                </select>
            </div>
            <div class="form-group">
                <label for="sensor_id" class="control-label col-md-4">
                    <span class="red">*</span> {t}Antenne ou sonde concernée :{/t}
                </label>
                <div class="col-md-8">
                    <select id="sensor_id" name="sensor_id" class="form-control">
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="testMode" class="control-label col-md-4">
                    {t}Mode test ?{/t}
                </label>
                <div class="col-md-1">
                    <input type="checkbox" id="testMode" value="1" name="testMode" class="form-control">
                </div>
            </div>
            <div class="form-group" hidden id="nbLinesGroup">
                <label for="nbLines" class="control-label col-md-4">
                    {t}Nombre de lignes à afficher ?{/t}
                </label>
                <div class="col-md-8">
                    <input type="number" name="nbLines" value="100" class="form-control">
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-danger">{t}Déclencher l'import{/t}</button>
            </div>
        </form>
    </div>
    <span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
</div>
{if $isTreated == 1}
    {if testMode == 1}
        <fieldset class="col-md-6">
            <legend>{t}Données prêtes à être importées{/t}</legend>
            <table class="table table-bordered table-hover datatable-nopaging">
                <thead>
                    {foreach $data[0] as $key=>$value}
                        <th>{$key}</th>
                    {/foreach}
                </thead>
                <tbody>
                    {foreach $data as $row}
                        <tr>
                            {foreach $row as $value}
                                <td>{$value}</td>
                            {/foreach}
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </fieldset>
    {/if}
    <fieldset class="col-md-6">
        <legend>{t}Messages d'information ou d'erreur{/t}</legend>
        <table class="table table-bordered table-hover datatable-nopaging">
            <thead>
                <tr>
                    <th>{t}N° de ligne{/t}</th>
                    <th>{t}Contenu{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $errors as $error}
                    <tr>
                        <td class="center">{$error.lineNumber}</td>
                        <td class="textareaDisplay">{$error.content}</td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </fieldset>
{/if}