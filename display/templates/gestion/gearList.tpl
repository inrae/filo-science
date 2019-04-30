
<div class="row">
        <fieldset class="col-md-12">
                <a href="index.php?module=sequenceGearChange&sequence_id={$data.sequence_id}&sequence_gear_id=0">
                        <img src="{$display}/images/edit.gif" height="25">{t}Nouvel engin de pêche{/t}
                    </a>
            <legend>{t}Engins de pêche{/t}</legend>
                <div class="col-md-12">
                    <table class="table table-bordered table-hover datatable" data-order='[[1,"desc"]]'>
                        <thead>
                            <tr>
                                <th>{t}Type d'engin{/t}</th>
                                <th>{t}Nombre{/t}</th>
                                <th>{t}Voltage{/t}</th>
                                <th>{t}Ampérage{/t}</th>
                                <th>{t}Profondeur{/t}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach $gears as $gear}
                            <tr>
                                <td class="center">
                                    <a href="index.php?module=sequenceChange&sequence_id={$gear.sequence_id}&sequence_gear_id={$gear.sequence_gear_id}">
                                        {$gear.gear_name}
                                    </a>
                                </td>
                                <td class="center">{$gear.gear_nb}</td>
                                <td class="center">{$gear.voltage}</td>
                                <td class="center">{$gear.amperage}</td>
                                <td class="center">{$gear.depth}</td>
                            </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
    
        </fieldset>
    </div>