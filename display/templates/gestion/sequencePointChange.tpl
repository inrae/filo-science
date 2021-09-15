<script>
$(document).ready(function () {
    var localisation = "{$data.localisation_id}";
    var facies = "{$data.facies_id}";
    if (localisation.length == 0) {
        try {
            localisation = Cookies.get("localisation");
            $("#localisation"+localisation).prop("checked", true);
        } catch {}
    }
    if (facies.length == 0) {
        try {
            facies = Cookies.get("facies");
            $("#facies"+facies).prop("checked", true);
        } catch {}
    }
    $(".localisation").change(function() {
        Cookies.set("localisation", $(this).val(), { expires: 7, sameSite: "strict", secure: true });
    });
    $(".facies").change(function() {
        Cookies.set("facies", $(this).val(), { expires: 7, sameSite: "strict", secure: true });
    });
});
</script>

<h2>{t}Saisie d'un point d'échantillonnage{/t}</h2>
<a href="index.php?module=campaignDisplay&campaign_id={$sequence.campaign_id}"><img
    src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t}&nbsp;{$sequence.campaign_name}</a>
&nbsp;
<a
href="index.php?module=operationDisplay&campaign_id={$sequence.campaign_id}&operation_id={$sequence.operation_id}&activeTab=tab-sequence">
<img src="display/images/display-green.png" height="25"> {t}Retour à l'opération{/t}&nbsp;{$sequence.operation_name}</a>

<a href="index.php?module=sequenceDisplay&sequence_id={$sequence.sequence_id}&activeTab=tab-point">
    <img src="display/images/display.png" height="25">{t}Retour à la séquence{/t}
</a>
<div class="row">
    <div class="col-md-6">

        <form class="form-horizontal protoform" id="paramForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="sequencePoint">
            <input type="hidden" name="action" value="Write">
            <input type="hidden" name="sequence_point_id" value="{$data.sequence_point_id}">
            <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
            <div class="form-group">
                <label for="sequence_point_number"  class="control-label col-md-4"> <span class="red">*</span>{t}N° du point :{/t}</label>
                <div class="col-md-8">
                    <input id="sequence_point_number" type="number" class="form-control nombre" name="sequence_point_number" value="{$data.sequence_point_number}" required>
                </div>
            </div>
            <div class="form-group">
                <label for="fish_number"  class="control-label col-md-4"> {t}Nombre de poissons :{/t}</label>
                <div class="col-md-8">
                        <input id="fish_number" type="number" class="form-control nombre" name="fish_number" value="{$data.fish_number}" autofocus>
                </div>
            </div>
            <div class="form-group">
                <label for="localisation_id"  class="control-label col-md-4"> {t}Localisation :{/t}</label>
                <div class="col-md-8">
                    {foreach $localisations as $localisation}
                        <div class="radio">
                            <label>
                                <input type="radio" class="localisation" name="localisation_id" id="localisation{$localisation.localisation_id}" value="{$localisation.localisation_id}" {if $data.localisation_id == $localisation.localisation_id}checked{/if}>
                                {$localisation.localisation_name}
                            </label>
                        </div>
                    {/foreach}
                </div>
            </div>
            <div class="form-group">
                <label for="facies_id"  class="control-label col-md-4"> {t}Facies :{/t}</label>
                <div class="col-md-8">
                    {foreach $faciess as $facies}
                        <div class="radio">
                            <label>
                                <input type="radio" class="facies" name="facies_id" id="facies{$facies.facies_id}" value="{$facies.facies_id}" {if $data.facies_id == $facies.facies_id}checked{/if}>
                                {$facies.facies_name}
                            </label>
                        </div>
                    {/foreach}
                </div>
            </div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.sequence_point_id > 0 }
                    <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
