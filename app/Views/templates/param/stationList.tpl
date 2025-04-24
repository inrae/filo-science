<h2>{t}Stations{/t}</h2>
<div class="row">
	<div class="col-md-12">
        {if $rights.manage == 1}
            <a href="stationChange&station_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="stationList" class="table table-bordered table-hover datatable-export-paging " >
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Code métier{/t}</th>
                    <th>{t}N° métier{/t}</th>
                    <th>{t}Cours d'eau{/t}</th>
                    <th>{t}Projet{/t}</th>
                    <th>{t}Longitude{/t}</th>
                    <th>{t}Latitude{/t}</th>
                    <th>{t}PK{/t}</th>
                    <th>{t}Type de station (tracking){/t}</th>
                </tr>
            </thead>
            <tbody>
                {section name=lst loop=$data}
                    <tr>
                        <td>{$data[lst].station_id}</td>
                        <td>
                            {if $rights.manage == 1}
                                <a href="stationChange&station_id={$data[lst].station_id}">
                                {$data[lst].station_name}
                            </a>
                            {else}
                                {$data[lst].station_name}
                            {/if}
                        </td>
                        <td>{$data[lst].station_code}</td>
                        <td class="center">{$data[lst].station_number}</td>
                        <td>{$data[lst].river_name}</td>
                        <td>{$data[lst].project_name}</td>
                        <td>{$data[lst].station_long}</td>
                        <td>{$data[lst].station_lat}</td>
                        <td>{$data[lst].station_pk}</td>
                        <td>{$data[lst].station_type_name}</td>
                    </tr>
                {/section}
            </tbody>
        </table>
    </div>
</div>

{if $rights["gestion"] == 1}
    <div class="row col-md-6">
        <fieldset>
            <legend>{t}Importer des stations depuis un fichier CSV{/t}</legend>
            <form class="form-horizontal protoform" id="metadataImport" method="post" action="index.php" enctype="multipart/form-data">

                <input type="hidden" name="module" value="stationImport">
                <div class="form-group">
                    <label for="upfile" class="control-label col-md-4"><span class="red">*</span> {t}Nom du fichier à importer (CSV) :{/t}</label>
                    <div class="col-md-8">
                        <input type="file" name="upfile" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="separator" class="control-label col-md-4"><span class="red">*</span> {t}Séparateur :{/t}</label>
                    <div class="col-md-8">
                        <select id="separator" class="form-control" name="separator">
                            <option value=";">{t}Point-virgule{/t}</option>
                            <option value=",">{t}Virgule{/t}</option>
                            <option value="t">{t}Tabulation{/t}</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="project_id" class="control-label col-md-4">{t}Projet éventuel de rattachement :{/t}</label>
                    <div class="col-md-8">
                        <select id="project_id" name="project_id" class="form-control">
                            <option value="" {if $data["project_id"] == ""} selected{/if}>{t}Choisissez...{/t}</option>
                            {foreach $projects as $project}
                                <option value="{$project.project_id}" {if $project.project_id == $data.project_id} selected {/if}>
                                    {$project.project_name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group center">
                    <button type="submit" class="btn btn-primary">{t}Importer les stations{/t}</button>
                </div>
                <div class="bg-info">
                    {t}Description du fichier :{/t}
                    <ul>
                        <li>{t}name : nom du lieu de prélèvement (obligatoire){/t}</li>
                        <li>{t}code : code métier de la station{/t}</li>
                        <li>{t}number : n° métier de la station{/t}</li>
                        <li>{t}long : longitude du point en projection WGS84, sous forme numérique (séparateur : point){/t}</li>
                        <li>{t}lat : latitude du point{/t}</li>
                        <li>{t}pk : point kilométrique de la station{/t}</li>
                        <li>{t}river : nom du cours d'eau{/t}</li>
                        <li>{t}station_type_id : code du type de station pour celles utilisées en tracking. Consultez la liste des codes ici :{/t}&nbsp;<a href="station_typeList">{t}Liste des types de stations{/t}</a></li>
                    </ul>
                </div>
            {$csrf}</form>
        </fieldset>
    </div>
{/if}
