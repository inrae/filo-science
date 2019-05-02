
<div class="row">
    <fieldset class="col-md-12">
        <a href="index.php?module=sequenceGearChange&sequence_id={$data.sequence_id}&sequence_gear_id=0">
            <img src="{$display}/images/new.png" height="25">{t}Nouvel engin de pêche{/t}
        </a>
    <!--<legend>{t}Engins de pêche{/t}</legend>-->
        <div class="col-md-12">
            <table class="table table-bordered table-hover datatable" data-order='[[1,"desc"]]'>
                <thead>
                    <tr>
                        <th>{t}Type d'engin{/t}</th>
                        <th>{t}Nombre{/t}</th>
                        <th>{t}Voltage{/t}</th>
                        <th>{t}Ampérage{/t}</th>
                        <th>{t}Nature du courant électrique{/t}</th>
                        <th>{t}Profondeur (m){/t}</th>
                        <th>{t}Méthode utilisée{/t}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $gears as $gear}
                    <tr>
                        <td class="center">
                            <a href="index.php?module=sequenceGearChange&sequence_id={$gear.sequence_id}&sequence_gear_id={$gear.sequence_gear_id}">
                                {$gear.gear_name}
                            </a>
                        </td>
                        <td class="center">{$gear.gear_nb}</td>
                        <td class="center">{$gear.voltage}</td>
                        <td class="center">{$gear.amperage}</td>
                        <td>{$gear.electric_current_type_name}</td>
                        <td class="center">{$gear.depth}</td>
                        <td>{$gear.gear_method_name}</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>

    </fieldset>
</div>
