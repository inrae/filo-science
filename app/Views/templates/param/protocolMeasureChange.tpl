<h2>{t}Rattachement des modèles de mesure au protocole {/t}<i>{$data.protocol_name}</i></h2>
<a href="protocolList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
&nbsp;<a href="protocolDisplay?protocol_id={$data.protocol_id}">
    <img src="display/images/display.png" height="25">{t}Retour au détail{/t}
</a>

<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal " id="paramForm" method="post" action="protocolMeasureWrite">
            <input type="hidden" name="moduleBase" value="protocolMeasure">
            <input type="hidden" name="protocol_id" value="{$data.protocol_id}">
            {foreach $measures as $measure}
                <div class="form-group">
                    <label class="control-label col-md-8">
                        {$measure.measure_template_name} -
                        <i>
                            {$measure.scientific_name}
                            {if !empty($measure.common_name) }
                                ({$measure.common_name})
                            {/if}
                        </i>
                    </label>
                    <div class="col-md-4 center">
                        <input  type="checkbox"  name="measure_template_id[]" value="{$measure.measure_template_id}" {if $measure.protocol_id > 0}checked{/if}>
                    </div>
                </div>
            {/foreach}
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
            </div>
        {$csrf}</form>
    </div>
</div>
