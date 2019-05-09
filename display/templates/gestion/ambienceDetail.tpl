<div class="row">

    <div class="col-md-6 form-display">
        <dl class="dl-horizontal">
            <dt>{t}Nom de l'ambiance :{/t}</dt>
            <dd>{$ambience.ambience_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Longitude :{/t}</dt>
            <dd>{$ambience.ambience_long}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Latitude :{/t}</dt>
            <dd>{$ambience.ambience_lat}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Situation :{/t}</dt>
            <dd>{$ambience.situation_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Localisation :{/t}</dt>
            <dd>{$ambience.localisation_name}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Longueur (en m) :{/t}</dt>
            <dd>{$ambience.ambience_length}</dd>
        </dl>
        <dl class="dl-horizontal">
            <dt>{t}Largeur (en m) :{/t}</dt>
            <dd>{$ambience.ambience_width}</dd>
        </dl>

        <fieldset>
            <legend>{t}Lame d'eau{/t}</legend>
            <dl class="dl-horizontal">
                <dt>{t}Classe de vitesse du courant (cm/s) :{/t}</dt>
                <dd>{$ambience.speed_name}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Vitesse du courant : moy / min / max (cm/s){/t}</dt>
                <dd>{$ambience.current_speed} / {$ambience.current_speed_min} / {$ambience.current_speed_max}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Hauteur d'eau : moy / min / max (cm){/t}</dt>
                <dd>{$ambience.water_height} / {$ambience.water_height_min} / {$ambience.water_height_max}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Régime hydrologique :{/t}</dt>
                <dd>{$ambience.flow_trend_name}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Turbidité :{/t}</dt>
                <dd>{$ambience.turbidity_name}</dd>
            </dl>
                        
        </fieldset>
        
    </div>
    <div class="col-md-6 form-display">
        <fieldset>
            <legend>{t}Caractéristiques du milieu{/t}</legend>
            <dl class="dl-horizontal">
                <dt>{t}Faciès :{/t}</dt>
                <dd>{$ambience.facies_name}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Végétation :{/t}</dt>
                <dd>{$ambience.vegetation_name}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Sinuosité :{/t}</dt>
                <dd>{$ambience.sinuosity_name}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Ombrage :{/t}</dt>
                <dd>{$ambience.shaddy_name}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Granulométrie principale :{/t}</dt>
                <dd>{$ambience.dominant_granulometry}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Granulométrie secondaire :{/t}</dt>
                <dd>{$ambience.secondary_granulometry}</dd>
            </dl>                                    
            <dl class="dl-horizontal">
                <dt>{t}Colmatage :{/t}</dt>
                <dd>{$ambience.clogging_name}</dd>
            </dl>                               
        </fieldset>
        <fieldset>
            <legend>{t}Abondance des caches{/t}</legend>
            <dl class="dl-horizontal">
                <dt>{t}Herbiers :{/t}</dt>
                <dd>{$ambience.herbarium_cache_abundance}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Branchages :{/t}</dt>
                <dd>{$ambience.branch_cache_abundance}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Végétation :{/t}</dt>
                <dd>{$ambience.vegetation_cache_abundance}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Sous-berge :{/t}</dt>
                <dd>{$ambience.subbank_cache_abundance}</dd>
            </dl>
            <dl class="dl-horizontal">
                <dt>{t}Cailloux, blocs :{/t}</dt>
                <dd>{$ambience.granulometry_cache_abundance}</dd>
            </dl>
        </fieldset>
    </div>
        
</div>





        
