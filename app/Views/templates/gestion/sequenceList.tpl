
<div class="row">
    <a href="sequenceChange&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}&sequence_id=0">
        <img src="display/images/new.png" height="25">{t}Nouvelle séquence{/t}
    </a>
</div>
<div class="row">

            <div class="col-md-8">
                <table class="table table-bordered table-hover datatable display" data-order='[[1,"desc"]]'>
                    <thead>
                        <tr>
                            <th>{t}Numéro d'ordre{/t}</th>
                            <th>{t}Nom{/t}</th>
                            <th>{t}Date-heure de début{/t}</th>
                            <th>{t}Date-heure de fin{/t}</th>
                            <th>{t}Durée de pêche (mn){/t}</th>
                            {if $rights.manage == 1}
                                <th class="center" title="{t}Dupliquer{/t}">
                                    <img src="display/images/copy.png" height="25">
                                </th>
                            {/if}
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $sequences as $sequence}
                        <tr>
                            <td class="center">
                                <a href="sequenceDisplay&sequence_id={$sequence.sequence_id}&operation_id={$data.operation_id}&campaign_id={$data.campaign_id}">
                                    {$sequence.sequence_number}
                                </a>
                            </td>
                            <td>{$sequence.sequence_name}</td>
                            <td>{$sequence.date_start}</td>
                            <td>{$sequence.date_end}</td>
                            <td class="center">{$sequence.fishing_duration}</td>
                            {if $rights.manage == 1}
                            <td class="center" title="{t}Dupliquer{/t}">
                                <a href="sequenceDuplicate&sequence_id={$sequence.sequence_id}&operation_id={$data.operation_id}&campaign_id={$data.campaign_id}">
                                    <img src="display/images/copy.png" height="25">
                                </a>
                            </td>
                            {/if}
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
            <div class="col-md-4">
                {include file="gestion/sequencesMap.tpl"}
            </div>


</div>