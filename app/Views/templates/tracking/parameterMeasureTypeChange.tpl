<h2>{t}Création/Modification d'un paramètre enregistré par les sondes{/t}</h2>
<div class="row">
    <a href="parameterMeasureTypeList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
</div>
<div class="row">
    <div class="col-md-6">
        <form class="form-horizontal " id="stationForm" method="post" action="parameterMeasureTypeWrite">
            <input type="hidden" name="moduleBase" value="parameterMeasureType">
            <input type="hidden" name="parameter_measure_type_id" value="{$data.parameter_measure_type_id}">
            <div class="form-group">
                <label for="parameter" class="control-label col-md-4"><span class="red">*</span>
                    {t}Nom ou code du paramètre :{/t}
                </label>
                <div class="col-md-8">
                    <input id="parameter" type="text" class="form-control" name="parameter" value="{$data.parameter}"
                        autofocus required>
                </div>
            </div>

            <div class="form-group">
                <label for="unit" class="control-label col-md-4">{t}Unité de mesure :{/t}</label>
                <div class="col-md-8">
                    <input id="unit" type="text" class="form-control" name="unit" value="{$data.unit}">
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.parameter_measure_type_id > 0 }
                <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
            {$csrf}
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>