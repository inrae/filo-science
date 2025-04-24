<h2>{t}Création - Modification d'un taxon{/t}</h2>
<a href="taxonList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="taxon">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="taxon_id" value="{$data.taxon_id}">
            <div class="form-group">
                <label for="paramName"  class="control-label col-md-4"><span class="red">*</span> {t}Nom scientifique :{/t}</label>
                <div class="col-md-8">
                    <input id="paramName" type="text" class="form-control" name="scientific_name" value="{$data.scientific_name}" autofocus required>
                </div>
            </div>
            <div class="form-group">
                <label for="author"  class="control-label col-md-4">{t}Auteur :{/t}</label>
                <div class="col-md-8">
                    <input id="author" type="text" class="form-control" name="author" value="{$data.author}" >
                </div>
            </div>
            <div class="form-group">
                <label for="common_name"  class="control-label col-md-4">{t}Nom commun :{/t}</label>
                <div class="col-md-8">
                    <input id="common_name" type="text" class="form-control" name="common_name" value="{$data.common_name}" >
                </div>
            </div>
            <div class="form-group">
                <label for="taxon_code"  class="control-label col-md-4">{t}Code SANDRE :{/t}</label>
                <div class="col-md-8">
                    <input id="taxon_code" type="text" class="form-control" name="taxon_code" value="{$data.taxon_code}" >
                </div>
            </div>
            <div class="form-group">
                <label for="fresh_code"  class="control-label col-md-4">{t}Code CSP (eau douce) :{/t}</label>
                <div class="col-md-8">
                    <input id="fresh_code" type="text" class="form-control" name="fresh_code" value="{$data.fresh_code}" >
                </div>
            </div>
            <div class="form-group">
                <label for="sea_code"  class="control-label col-md-4">{t}Code CSP (eau de mer) :{/t}</label>
                <div class="col-md-8">
                    <input id="sea_code" type="text" class="form-control" name="sea_code" value="{$data.sea_code}" >
                </div>
            </div>
            <div class="form-group">
                <label for="ecotype"  class="control-label col-md-4">{t}Écotype :{/t}</label>
                <div class="col-md-8">
                    <input id="ecotype" type="text" class="form-control" name="ecotype" value="{$data.ecotype}" >
                </div>
            </div>
            <div class="form-group">
                <label for="length_max"  class="control-label col-md-4">{t}Longueur maxi (mm) :{/t}</label>
                <div class="col-md-8">
                    <input id="length_max" type="text" class="form-control" name="length_max" value="{$data.length_max}" >
                </div>
            </div>
            <div class="form-group">
                <label for="weight_max"  class="control-label col-md-4">{t}Poids maxi (g) :{/t}</label>
                <div class="col-md-8">
                    <input id="weight_max" type="text" class="form-control" name="weight_max" value="{$data.weight_max}" >
                </div>
            </div>


            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.taxon_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        {$csrf}</form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>