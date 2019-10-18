<script>
    var mapIsChange = true;
</script>
<h2>{t}Création - Modification d'une localisation manuelle{/t}</h2>
<div class="row">
    <a href="index.php?module=individualTrackingList&individual_id={$data.individual_id}">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
</div>
<div class="row">
    <div class="col-md-8">
        <div class="form-display">
            <dl class="dl-horizontal">
                <dt>{t}Poisson :{/t}</dt>
                <dd>{$individual.individual_id} {$individual.scientific_name}</dd>
            </dl>
            {if strlen($individual.tag) > 0}
            <dl class="dl-horizontal">
                <dt>{t}Tag RFID{/t}</dt>
                <dd>{$individual.tag}</dd>
            </dl>
            {/if}
            {if strlen($individual.transmitter) > 0}
            <dl class="dl-horizontal">
                <dt>{t}Transmetteur{/t}</dt>
                <dd>{$individual.transmitter}</dd>
            </dl>
            {/if}
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
<form class="form-horizontal protoform" id="locationForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="location">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="location_id" value="{$data.location_id}">
            <input type="hidden" name="individual_id" value="{$data.individual_id}">
            <div class="form-group">
                <label for="antenna_type_id"  class="control-label col-md-4">{t}Type d'antenne mobile :{/t}</label>
                <div class="col-md-8">
                    <select class="form-control" autofocus name="antenna_type_id" id="antenna_id">
                        <option value="" {if $data.antenna_id == ""}selected{/if}>
                            {t}Sélectionnez{/t}
                        </option>
                        {foreach $antennas as $antenna}
                            <option value="{$antenna.antenna_type_id}" {if $antenna.antenna_type_id == $data.antenna_type_id}selected{/if}>
                                {$antenna.antenna_type_name}
                            </option>
                        {/foreach}
                    </select>
                </div>
            </div>     
            <div class="form-group">
                <label for="detection_date" class="control-label col-md-4"><span class="red">*</span> {t}Date-heure de détection{/t}</label>
                <div class="col-md-8">
                    <input class="form-control" id="detection_date" name="detection_date" value="{$data.detection_date}" required>
                </div>
            </div>
            <div class="form-group">
                <label for="location_pk"  class="control-label col-md-4">{t}Point kilométrique :{/t}</label>
                <div class="col-md-8">
                    <input id="location_pk" class="form-control taux" name="location_pk" value="{$data.location_pk}">
                </div>
            </div>
            <div class="form-group">
                <label for="signal_force"  class="control-label col-md-4">{t}Force du signal :{/t}</label>
                <div class="col-md-8">
                    <input id="signal_force" class="form-control nombre" name="signal_force" value="{$data.signal_force}">
                </div>
            </div>
            <div class="form-group">
                <label for="observation"  class="control-label col-md-4">{t}Observations :{/t}</label>
                <div class="col-md-8">
                    <textarea id="observation" class="form-control" name="observation" rows="5">{$data.observation}</textarea>
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.location_id > 0 }
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>

        <div class="col-md-6">
            {include file="param/locationMap.tpl"}
        </div>
    </div>
    <span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>