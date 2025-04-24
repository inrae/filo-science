<div class="row">
    <div class="col-md-6">
        {if $rights.manage == 1}
            <a href="antennaChange?station_id={$data.station_id}&antenna_id=0">
                <img src="display/images/new.png" height="25">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="antennaList" class="table table-bordered table-hover datatable-nopaging " >
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Code{/t}</th>
                    <th>{t}Technologie{/t}</th>
                    <th>{t}Rayon de réception (en mètres){/t}</th>
                    <th>{t}Date de mise en service{/t}</th>
                    <th>{t}Date de retrait{/t}</th>
                    {if $rights.manage == 1}
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
                        <td>{$antenna.technology_type_name}</td>
                        <td>{$antenna.radius}</td>
                        <td>{$antenna.date_from}</td>
                        <td>{$antenna.date_to}</td>
                        {if $rights.manage == 1}
                            <td class="center">
                                <a href="antennaChange?station_id={$data.station_id}&antenna_id={$antenna.antenna_id}" title="{t}Modifier{/t}">
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
