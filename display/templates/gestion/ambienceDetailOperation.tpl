<div class="row">
    <fieldset class="col-md-12">
        <legend>{t}Ambiance{/t}</legend>
        <a href="index.php?module=ambienceChange&operation_id={$ambience.operation_id}&ambience_id={$ambience.ambience_id}&origin=operation">
            <img src="display/images/edit.gif" height="25">{t}Modifier{/t}
        </a>
        {include file="gestion/ambienceDetail.tpl"}
    </fieldset>
</div>