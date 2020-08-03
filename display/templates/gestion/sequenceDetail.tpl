<div class="row">
    <fieldset class="col-md-6">
        <legend>{t}Informations générales{/t}</legend>
        <a href="index.php?module=sequenceChange&campaign_id={$data.campaign_id}&sequence_id={$data.sequence_id}">
                <img src="display/images/edit.gif" height="25">{t}Modifier{/t}
            </a>
        <div class="form-display">
            <dl class="dl-horizontal">
                <dt>{t}N° de la séquence :{/t}</dt>
                <dd>{$data.sequence_number}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Nom de la séquence :{/t}</dt>
                <dd>{$data.sequence_name}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Date/heure de début :{/t}</dt>
                <dd>{$data.date_start}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Date/heure de fin :{/t}</dt>
                <dd>{$data.date_end}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Durée de pêche (en mn) :{/t}</dt>
                <dd>{$data.fishing_duration}</dd>
            </dl>

        </div>
    </fieldset>
</div>