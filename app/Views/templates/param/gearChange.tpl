<h2>{t}Création - Modification d'un engin de pêche{/t}</h2>
<a href="gearList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="gear">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="gear_id" value="{$data.gear_id}">
            <div class="form-group">
                <label for="paramName"  class="control-label col-md-4"><span class="red">*</span> {t}Libellé :{/t}</label>
                <div class="col-md-8">
                    <input id="paramName" type="text" class="form-control" name="gear_name" value="{$data.gear_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="gear_length"  class="control-label col-md-4">{t}Longueur (en mètres) :{/t}</label>
                <div class="col-md-8">
                    <input id="gear_length" type="text" class="form-control taux" name="gear_length" value="{$data.gear_length}" >
                </div>
            </div>
            <div class="form-group">
                <label for="gear_height"  class="control-label col-md-4">{t}Hauteur (en mètres) :{/t}</label>
                <div class="col-md-8">
                    <input id="gear_height" type="text" class="form-control taux" name="gear_height" value="{$data.gear_height}" >
                </div>
            </div>
            <div class="form-group">
                <label for="mesh_size"  class="control-label col-md-4">{t}Taille du maillage (texte libre) :{/t}</label>
                <div class="col-md-8">
                    <input id="mesh_size" type="text" class="form-control" name="mesh_size" value="{$data.mesh_size}" >
                </div>
            </div>


            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.gear_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        {$csrf}</form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>