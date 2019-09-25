<div class="row">
    <div class="col-md-6">
        {if $droits.gestion == 1}
            <a href="index.php?module=probeChange&station_id={$data.station_id}&probe_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="stationList" class="table table-bordered table-hover datatable-nopaging " >
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Code{/t}</th>
                    {if $droits.gestion == 1}
                        <th class="center">
                            <img src="display/images/edit.gif" height="25" title="{t}Modifier{/t}">
                        </th>
                    {/if}
                </tr>
            </thead>
            <tbody>
                {foreach $probes as $probe}
                    <tr>
                        <td class="center">{$probe.probe_id}</td>
                        <td>{$probe.probe_code}</td>
                        {if $droits.gestion == 1}
                            <td class="center">
                                <a href="index.php?module=probeChange&station_id={$data.station_id}&probe_id={$probe.probe_id}" title="{t}Modifier{/t}">
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