<h2>{t}Création - Modification d'un type d'émetteur{/t}</h2>
<a href="transmitter_typeList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="transmitter_type">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="transmitter_type_id" value="{$data.transmitter_type_id}">
            <div class="form-group">
                <label for="paramName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom ou modèle de l'émetteur :{/t}</label>
                <div class="col-md-8">
                    <input id="paramName" type="text" class="form-control" name="transmitter_type_name" value="{$data.transmitter_type_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="characteristics"  class="control-label col-md-4">{t}Caractéristiques :{/t}</label>
                <div class="col-md-8">
                    <textarea rows="5" id="characteristics" type="text" class="form-control" name="characteristics">{$data.characteristics}</textarea>
                </div>
            </div>
            <div class="form-group">
                <label for="technology"  class="control-label col-md-4">{t}Technologie employée :{/t}</label>
                <div class="col-md-8">
                    <input id="technology" type="text" class="form-control" name="technology" value="{$data.technology}" >
                </div>
            </div>
            
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.transmitter_type_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        {$csrf}</form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>