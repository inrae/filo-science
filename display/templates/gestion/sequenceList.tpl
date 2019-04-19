
<div class="row">
    <fieldset class="col-md-12">
            <a href="index.php?module=sequenceChange&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}&sequence_id=0">
                    <img src="{$display}/images/edit.gif" height="25">{t}Nouvelle séquence{/t}
                </a>
        <legend>{t}Séquences{/t}</legend>
            <div class="col-md-12">
                <table class="table table-bordered table-hover datatable ">
                    <thead>
                        <tr>
                            <th>{t}Numéro d'ordre{/t}</th>
                            <th>{t}Date-heure de début{/t}</th>
                            <th>{t}Date-heure de fin{/t}</th>
                            <th>{t}Durée de pêche (mn){/t}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $sequences as $row}
                        <tr>
                            <td class="center">
                                <a href="index.php?module=sequenceDisplay&sequence_id={$row.sequence_id}&operation_id={$data.operation_id}&campaign_id={$data.campaign_id}">
                                    {$row.sequence_id}
                                </a>
                            </td>
                            <td>{$row.date_start}</td>
                            <td>{$row.date_end}</td>
                            <td class="center">{$row.fishing_duration}</td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>

    </fieldset>
</div>