<h2>{t}Modification manuelle d'une détection{/t}</h2>
<div class="row">
    <a href="individualTrackingList?individual_id={$data.individual_id}">
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
            {if !empty($individual.tag)}
            <dl class="dl-horizontal">
                <dt>{t}Tag RFID{/t}</dt>
                <dd>{$individual.tag}</dd>
            </dl>
            {/if}
            {if !empty($individual.transmitter)}
            <dl class="dl-horizontal">
                <dt>{t}Transmetteur{/t}</dt>
                <dd>{$individual.transmitter}</dd>
            </dl>
            {/if}
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-8">
        <form class="form-horizontal " id="probe_parameterForm" method="post" action="detectionWrite">
            <input type="hidden" name="moduleBase" value="detection">
            <input type="hidden" name="detection_id" value="{$data.detection_id}">
            <input type="hidden" name="individual_id" value="{$data.individual_id}">
            <fieldset>
                <legend>{t}Localisation{/t}</legend>
                <div class="form-group">
                    <label for="antenna_id"  class="control-label col-md-4">{t}Antenne fixe :{/t}</label>
                    <div class="col-md-8">
                        <select class="form-control" autofocus name="antenna_id" id="antenna_id">
                            <option value="" {if $data.antenna_id == ""}selected{/if}>
                                {t}Sélectionnez{/t}
                            </option>
                            {foreach $antennas as $antenna}
                                <option value="{$antenna.antenna_id}" {if $antenna.antenna_id == $data.antenna_id}selected{/if}>
                                    {$antenna.station_name} {$antenna.antenna_code} ({$antenna.technology_type_name})
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="location_id"  class="control-label col-md-4">{t}Localisation manuelle :{/t}</label>
                    <div class="col-md-8">
                        <select class="form-control"  name="location_id" id="location_id">
                            <option value="" {if $data.location_id == ""}selected{/if}>
                                {t}Sélectionnez{/t}
                            </option>
                            {foreach $locations as $location}
                                <option value="{$location.location_id}" {if $location.location_id == $data.location_id}selected{/if}>
                                    {$location.river_name} {$location.location_pk} ({$location.location_long}x{$location.location_lat})
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
            </fieldset>
            <fieldset>
                <legend>{t}Données de détection{/t}</legend>
                <div class="form-group">
                    <label for="detection_date" class="control-label col-md-4"><span class="red">*</span> {t}Date-heure de détection{/t}</label>
                    <div class="col-md-8">
                        <input class="form-control" id="detection_date" name="detection_date" value="{$data.detection_date}" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="nb_events"  class="control-label col-md-4">{t}Nombre d'événements :{/t}</label>
                    <div class="col-md-8">
                        <input id="nb_events" class="form-control nombre" name="nb_events" value="{$data.nb_events}">
                    </div>
                </div>
                <div class="form-group">
                    <label for="duration"  class="control-label col-md-4">{t}Durée de détection, en secondes :{/t}</label>
                    <div class="col-md-8">
                        <input id="duration" class="form-control taux" name="duration" value="{$data.duration}">
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
                <div class="form-group">
                    <label for="nb_events"  class="control-label col-md-4">{t}Détection valide ?{/t}</label>
                    <div class="col-md-8">
                        <div class="btn-group btn-toggle" data-toggle="buttons">
                            <label class="radio-inline">
                                <input type="radio" id="validity1" name="validity" value="1"  {if $data.validity ==1}checked{/if}>{t}oui{/t}
                            </label>
                            <label class="radio-inline">
                                <input type="radio" id="validity0" name="validity" value="0"  {if $data.validity ==0}checked{/if}>{t}non{/t}
                            </label>
                        </div>
                    </div>
                </div>
        </fieldset>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.detection_id > 0 }
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        {$csrf}</form>
    </div>
</div>

<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
