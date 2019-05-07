<div class="row">
    <fieldset class="col-md-6">
        <legend>{t}Ambiance{/t}</legend>
        <a href="index.php?module=ambienceChange&sequence_id={$ambience.sequence_id}&ambience_id={$ambience.ambience_id}">
            <img src="{$display}/images/edit.gif" height="25">{t}Modifier{/t}
        </a>
        {include file="gestion/ambienceDetail.tpl"}
    </fieldset>
</div>