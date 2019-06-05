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
        
    </div>
</div>