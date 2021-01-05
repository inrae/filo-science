<script>
    $(document).ready(function () {
        var cookieContent;
        var projectId = "{$projects[0].project_id}";
        var importDescriptionId = "{$imports[0].import_description_id}";
        var sensorId = 0;

        $("#import_description_id, #project_id").change(function () {
            var import_description_id = $("#import_description_id").val();
            var project_id = $("#project_id").val();
            if (import_description_id > 0 && project_id > 0) {
                setStations(import_description_id, project_id, sensorId);
            }
        });
        $("#testMode:checkbox").change(function () {
            if (this.checked) {
                $("#nbLinesGroup").show();
            } else {
                $("#nbLinesGroup").hide();
            }
        });

        function setStations(import_description_id, project_id, sensor_id = 0) {
            $.ajax({
                url: "index.php",
                data: {
                    "module": "stationTrackingGetSensors",
                    "import_description_id": import_description_id,
                    "project_id": project_id
                    }
            })
            .done(function (value) {
                var val = JSON.parse(value);
                var options = '<option value="0">{t}Sélectionnez{/t}</option>';
                val.forEach(function (element) {
                    options += '<option value="'+ element.sensor_id + '"';
                    if (sensor_id == element.sensor_id) {
                        options += ' selected ';
                    }
                    options += ' >' + element.station_name + ' '+element.station_code + ':'+element.sensor_code+'</option>';
                });
                $("#sensor_id").html(options);
                $("#sensor_id option[value"+sensorId+"]").prop("selected", "selected");
            });
        }

        $("#importForm").submit( function (event) {
            //event.preventDefault();
            /**
             * set the cookie
             */
            cookieContent = {
                "import_description_id": $("#import_description_id").val(),
                "project_id": $("#project_id").val(),
                "sensor_id": $("#sensor_id").val()
            };
            if ($("#testMode").is(":checked")) {
                cookieContent.testMode = "1";
            } else {
                cookieContent.testMode = "0";
            }
            if ($("#rewrite").is(":checked")) {
                cookieContent.rewrite = "1";
            } else {
                cookieContent.rewrite = "0";
            }
            Cookies.set ("importExec", JSON.stringify(cookieContent), { expires: 60});
            $("#submit").hide();
            $("#spinner").show();
        });

        /**
         * get the current variables saved in the cookie
         */
        try {
            cookieContent = JSON.parse(Cookies.get("importExec"));
            if (cookieContent !== undefined) {
                $("#project_id option[value="+cookieContent.project_id+"]").prop("selected", "selected");
                $("#import_description_id option[value="+cookieContent.import_description_id+"]").prop("selected", "selected");
                sensorId = cookieContent.sensor_id;
                if (cookieContent.project_id > 0 && cookieContent.import_description_id > 0) {
                    setStations(cookieContent.import_description_id, cookieContent.project_id, cookieContent.sensor_id);
                }
                if (cookieContent.testMode == "1") {
                    $("#testMode").prop("checked", true);
                    $("#nbLinesGroup").show();
                }
                if (cookieContent.rewrite == "1") {
                    $("#rewrite").prop("checked", true);
                } else {
                    $("#rewrite").prop("checked", false);
                }
            } else {
                /**
                 * set default values
                 */
                if (importDescriptionId > 0 && projectId > 0) {
                    setStations(importDescriptionId, projectId);
                }
            }
        } catch {}
        /**
         * Get default station
         */
         if (importDescriptionId > 0 && projectId > 0) {
            setStations(importDescriptionId,projectId, sensorId);
         }
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
                <label for="project_id" class="col-md-4 control-label">{t}Projet :{/t}</label>
                <div class="col-md-8">
                    <select id="project_id" name="project_id" class="form-control">
                        {foreach $projects as $project}
                            <option id="project{$project.project_id}" value="{$project.project_id}">
                                {$project.project_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="sensor_id" class="control-label col-md-4">
                    <span class="red">*</span> {t}Antenne ou sonde concernée (si vide, le code de l'antenne doit être présent dans le fichier) :{/t}
                </label>
                <div class="col-md-8">
                    <select id="sensor_id" name="sensor_id" class="form-control">
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="rewrite" class="control-label col-md-4">
                    {t}Écraser les importations précédentes ?{/t}
                </label>
                <div class="col-md-1">
                    <input type="checkbox" id="rewrite" value="1" name="rewrite" class="form-control" checked>
                </div>
            </div>
            <div class="form-group">
                <label for="testMode" class="control-label col-md-4">
                    {t}Mode test ?{/t}
                </label>
                <div class="col-md-1">
                    <input type="checkbox" id="testMode" value="1" name="testMode" class="form-control" {if $testMode == 1}checked{/if}>
                </div>
            </div>
            <div class="form-group" id="nbLinesGroup" {if $testMode != 1}hidden{/if}>
                <label for="nbLines" class="control-label col-md-4">
                    {t}Nombre de lignes à afficher ?{/t}
                </label>
                <div class="col-md-8">
                    <input type="number" name="nbLines" value="100" class="form-control">
                </div>
            </div>
            <div class="form-group center">
                <button id="submit" type="submit" class="btn btn-primary button-danger">{t}Déclencher l'import{/t}</button>
                <img id="spinner" src="display/images/spinner.gif" hight="25" hidden>
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
<div class="row">
    {if $isTreated == 1}
        {if $testMode == 1}
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
</div>
