<a href="index.php?module=analysisChange&sequence_id={$data.sequence_id}&analysis_id={$analysis.analysis_id}">
        <img src="display/images/edit.gif" height="25">{t}Modifier{/t}
    </a>
<div class="row">

    <div class="col-md-6 form-display">
        <dl class="dl-horizontal">
            <dt>{t}Date de l'analyse :{/t}</dt>
            <dd>{$analysis.analysis_date}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}pH :{/t}</dt>
            <dd>{$analysis.ph}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}température (°C) :{/t}</dt>
            <dd>{$analysis.temperature}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}% de saturation O2 :{/t}</dt>
            <dd>{$analysis.o2_pc}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}O2, en mg/l :{/t}</dt>
            <dd>{$analysis.o2_mg}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Salinité :{/t}</dt>
            <dd>{$analysis.salinity}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Conductivité, en µS/cm :{/t}</dt>
            <dd>{$analysis.conductivity}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Secchi, en mètre :{/t}</dt>
            <dd>{$analysis.secchi}</dd>
        </dl>
        {if !empty($other_analysis) }
            <fieldset>
                <legend>{t}Analyses complémentaires{/t}</legend>
                {foreach $other_analysis as $key=>$value}
                    {if !empty($value) }
                        <dl class="dl-horizontal">
                            <dt>{t 1=$key}%1 :{/t}</dt>
                            <dd>
                            {if is_array($value) }
                                {foreach $value as $val}
                                    {$val}<br>
                                {/foreach}
                            {else}
                                {if substr($value, 0, 5) == "http:" || substr($value, 0, 6) == "https:"}
                                    <a href="{$value}" target="_blank" rel="noopener">{$value}</a>
                                {else}
                                    {$value}
                                {/if}
                            {/if}
                            </dd>
                        </dl>
                    {/if}
                {/foreach}
            </fieldset>
        {/if}

    </div>
</div>
