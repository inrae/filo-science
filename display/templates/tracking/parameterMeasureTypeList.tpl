<h2>{t}Liste des paramètres enregistrés par les sondes{/t}</h2>
<div class="col-md-6">
        {if $droits.gestion == 1}
        <a href="index.php?module=parameterMeasureTypeChange&parameter_measure_type_id=0">
            <img src="display/images/new.png" height="25">
            {t}Nouveau...{/t}
        </a>
        {/if}
        <table id="parameter_measure_typeList" class="table table-bordered table-hover datatable-nopaging ">
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Code ou nom du paramètre{/t}</th>
                    <th>{t}Unité de mesure{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $parameters as $parameter}
                <tr>
                    <td class="center">
                        {if $droits.gestion == 1}
                            <a href="index.php?module=parameterMeasureTypeChange&parameter_measure_type_id={$parameter.parameter_measure_type_id}" title="{t}Modifier{/t}">
                                {$parameter.parameter_measure_type_id}
                            </a>
                        {else}
                            {$parameter.parameter_measure_type_id}
                        {/if}
                    </td>
                    <td>{$parameter.parameter} </td> 
                    <td class="center">
                        {$parameter.unit}
                    </td>
                   
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>