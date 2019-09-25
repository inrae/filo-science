<div class="row">
    <div class="col-md-12">
        {if $droits.gestion == 1}
            <a href="index.php?module=antennaChange&station_id={$data.station_id}&antenna_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="stationList" class="table table-bordered table-hover datatable-nopaging " >
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Code{/t}</th>
                    <th>{t}Diamètre de réception (en mètres){/t}</th>
                    {if $droits.gestion == 1}
                        <th class="center">
                            <img src="display/images/edit.gif" height="25" title="{t}Modifier{/t}">
                        </th>
                    {/if}
                </tr>
            </thead>
            <tbody>
                {foreach $antennas as $antenna}
                    <tr>
                        <td class="center">{$antenna.antenna_id}</td>
                        <td>{$antenna.antenna_code}</td>
                        <td>{$antenna.diameter}</td>
                        {if $droits.gestion == 1}
                            <td class="center">
                                <a href="index.php?module=antennaChange&station_id={$data.station_id}&antenna_id={$antenna.antenna_id}" title="{t}Modifier{/t}">
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