<h2>{t}Création/Modification d'une sonde - station{/t}&nbsp;{$station.station_name}</h2>
<div class="row">
    <a href="index.php?module=stationTrackingList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
    &nbsp;
    <a href="index.php?module=stationTrackingDisplay&station_id={$station.station_id}">
        <img src="display/images/display.png" height="25">
        {t}Retour à la station{/t}
    </a>
</div>
<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal protoform" id="probeForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="probe">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="station_id" value="{$data.station_id}">
            <input type="hidden" name="probe_id" value="{$data.probe_id}">
            <div class="form-group">
                <label for="probeCode"  class="control-label col-md-4"><span class="red">*</span> {t}Code de la sonde :{/t}</label>
                <div class="col-md-8">
                    <input id="probeCode" type="text" class="form-control" name="probe_code" value="{$data.probe_code}" autofocus required>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.probe_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
    {if $data.probe_id > 0}
        <fieldset class="col-md-6">
            <legend>{t}Paramètres enregistrés par la sonde{/t}</legend>
            <a href="index.php?module=probeChange&probe_id={$data.probe_id}&station_id={$station.station_id}&probe_parameter_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau paramètre{/t}
            </a>
            <table id="table-parameter" class="table table-bordered table-hover datatable-nopaging ">
                <thead>
                    <tr>
                        <th>{t}Id{/t}</th>
                        <th>{t}Code fourni par la sonde{/t}</th>
                        <th>{t}Paramètre enregistré{/t}</th>
                        <th>{t}Unité de mesure{/t}</th>
                        <th class="center">
                            <img src="display/images/edit.gif" height="25">
                        </th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $parameters as $parameter}
                        <tr>
                            <td class="center">{$parameter.probe_parameter_id}</td>
                            <td>{$parameter.probe_code}</td>
                            <td>{$parameter.parameter}</td>
                            <td>{$parameter.unit}</td>
                            <td class="center">
                                <a href="index.php?module=probeChange&probe_id={$data.probe_id}&station_id={$station.station_id}&probe_parameter_id={$parameter.probe_parameter_id}" title="{t}Modifier{/t}">
                                    <img src="display/images/edit.gif" height="25">
                                </a>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </fieldset>
    {/if}
</div>
{if isset($probe_parameter)}
    <div class="row">
        <div class="col-md-8">
            <form class="form-horizontal protoform" id="probe_parameterForm" method="post" action="index.php">
                <input type="hidden" name="moduleBase" value="probeParameter">
                <input type="hidden" name="action" value="Write">
                <input type="hidden" name="station_id" value="{$data.station_id}">
                <input type="hidden" name="probe_parameter_id" value="{$data.probe_parameter_id}">
                <input type="hidden" name="probe_id" value="{$data.probe_id}">
                <div class="form-group">
                    <label for="probe_code"  class="control-label col-md-4"><span class="red">*</span> {t}Code utilisé dans la sonde pour définir le paramètre :{/t}</label>
                    <div class="col-md-8">
                        <input id="probe_code" type="text" class="form-control" name="probe_code" value="{$probe_parameter.probe_code}" autofocus required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="parameter"  class="control-label col-md-4"><span class="red">*</span> {t}Paramètre mesuré (libellé normalisé) :{/t}</label>
                    <div class="col-md-8">
                        <input id="parameter" type="text" class="form-control" name="parameter" value="{$probe_parameter.parameter}" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="unit"  class="control-label col-md-4"> {t}Unité de mesure :{/t}</label>
                    <div class="col-md-8">
                        <input id="unit" type="text" class="form-control" name="unit" value="{$probe_parameter.unit}">
                    </div>
                </div>
                <div class="form-group center">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                    {if $data.probe_parameter_id > 0 }
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                    {/if}
                </div>
            </form>
        </div>
    </div>
{/if}
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>