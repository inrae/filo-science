<h2>{t}Détail d'un protocole{/t}</h2>
<div class="row">
    <div class="col-md-12">
        <a href="index.php?module=protocolList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
        {if $droits.gestion == 1}
            &nbsp;
            <a href="index.php?module=protocolChange&protocol_id=0">
                <img src="{$display}/images/new.png" height="25">
                {t}Nouveau protocole{/t}
            </a>
            &nbsp;
            <a href="index.php?module=protocolChange&uid={$data.protocol_id}">
                <img src="{$display}/images/edit.gif" height="25">{t}Modifier{/t}
            </a>
        {/if}
    </div>
</div>

<div class="row">
    <fieldset class="col-md-8">
        <legend>{t}Informations générales{/t}</legend>
        <div class="form-display">
            <dl class="dl-horizontal">
                <dt>{t}UID et référence :{/t}</dt>
                <dd>{$data.uid} {$data.identifier}</dd>
            </dl>
        </div>
    </fieldset>
</div>