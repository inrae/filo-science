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
                    <th class="center">{t}Mesures enregistrées{/t}</th>
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
                        <td {if $probe.probe_id == $selectedProbe}class="itemSelected"{/if}>{$probe.probe_code}</td>
                        <td class="center">
                            <a href="index.php?module=stationTrackingDisplay&station_id={$data.station_id}&probe_id={$probe.probe_id}">
                                <img src="display/images/result.png" height="25">
                            </a>
                        </td>
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
    <div class="col-md-6">
        {if isset($measures)}
            <fieldset>
                <legend>{t}Mesures enregistrées{/t}</legend>
                <a href="index.php?module=stationTrackingDisplay&station_id={$data.station_id}&probe_id={$probe.probe_id}&offset={$offset - 30}">
                    &lt;{t}précédent{/t}
                </a>
                &nbsp;
                <a href="index.php?module=stationTrackingDisplay&station_id={$data.station_id}&probe_id={$probe.probe_id}&offset={$offset + 30}">
                    {t}suivant{/t}&gt;
                </a>

                <table id="measures" class="table table-bordered table-hover datatable-nopaging">
                    <thead>
                        <tr>
                            {foreach $measures[0] as $key=>$value}
                                <th>{$key}</th>
                            {/foreach}
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $measures as $measure}
                            <tr>
                                {foreach $measure as $value}
                                    <td>{$value}</td>
                                {/foreach}
                            </tr>
                        {/foreach}
                    </tbody>
                </table>
            </fieldset>
        {/if}
    </div>
</div>