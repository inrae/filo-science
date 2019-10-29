{include file="import/modelPatternJS.tpl"}
<script type="text/javascript">
    $(document).ready(function () {
        var pattern = $("#pattern").val();
        if (pattern.length > 0) {
            pattern = pattern.replace(/&quot;/g, '"');
            pattern = JSON.parse(pattern);
        } else {}
        patternForm(pattern);
        $('#exportModelForm').submit(function (event) {
            if ($("#action").val() == "Write") {
                $('#alpacaPattern').alpaca().refreshValidationState(true);
                if (!$('#alpacaPattern').alpaca().isValid(true)) {
                    alert("{t}La définition du modèle n'est pas valide.{/t}");
                    event.preventDefault();
                }
            }
        });
    });
</script>
<h2>{t}Création - Modification d'un modèle d'export de données{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <a href="index.php?module=exportModelList">
            <img src="display/images/list.png" height="25">
            {t}Retour à la liste{/t}
        </a>
        {if $data.export_model_id > 0}
            <a href="index.php?module=exportModelDisplay&export_model_id={$data.export_model_id}">
                <img src="display/images/display.png" height="25">{t}Retour au détail{/t}
            </a>
        {/if}
        <form class="form-horizontal protoform" id="exportModelForm" method="post" action="index.php">
            <input type="hidden" name="moduleBase" value="exportModel">
            <input type="hidden" id="action" name="action" value="Write">
            <input type="hidden" name="export_model_id" value="{$data.export_model_id}">
            <input type="hidden" name="pattern" id="pattern" value="{$data.pattern}">
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
            </div>
            <div class="form-group">
                <label for="export_model_name"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du modèle :{/t}</label>
                <div class="col-md-8">
                <input id="export_model_name" type="text" class="form-control" name="export_model_name" value="{$data.export_model_name}" required autofocus>
                </div>
            </div>
            <div id="alpacaPattern"></div>
            <div class="form-group center">
                <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                {if $data.export_model_id > 0 }
                 <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                {/if}
            </div>
        </form>
    </div>
    <div class="col-md-6">
        <div class="bg-info">
            <h3>{t}Description des champs à renseigner{/t}</h3>
            <ul>
                <li>{t}Le nom de la table doit correspondre au nom dans la base de données{/t}</li>
                <li>{t}L'alias va être utilisé pour renommer la table dans le fichier d'export, si celle-ci peut être liée à deux autres tables. Exemple dans Filo-Science : la table ambience est référencée soit par operation, soit par sequence, et doit donc être dotée d'un alias. Les alias, s'ils ne sont par renseignés, seront déduits du nom de la table lors de l'importation.{/t}</li>
                <li>{t}La clé primaire correspond à la clé automatique générée par la base de données. Elle ne sera pas renseignée dans le cas d'une table n-n, dont la clé est composée de deux champs{/t}</li>
                <li>{t}La clé métier est la clé unique utilisée pour identifier un enregistrement. Il peut s'agir soit d'un champ signifiant (nom d'un taxon, par exemple), soit de la clé primaire. Si cette clé est renseignée, le programme d'importation pourra modifier un enregistrement pré-existant en recherchant la clé primaire à partir de cette information{/t}</li>
                <li>{t}La clé étrangère correspond à la colonne permettant d'identifier l'enregistrement parent, pour les tables filles{/t}</li>
                <li>{t}La liste des tables liées contient les alias (ou les noms des tables, si ceux-ci ne sont pas renseignés) des tables filles. Chaque alias devra faire l'objet d'une description.{/t}</li>
                <li>{t}La liste des clés à exporter est en principe générée par l'application. Elle est affichée dans le masque de saisie pour rappeler que l'information existe et peut être renseignée.{/t}</li>
            </ul>
            <h3>Fonctionnement de l'importation</h3>
            <ul>
                <li>{t}Si la clé métier est renseignée, le programme va rechercher un enregistrement pré-existant dans la table qui correspond à la valeur indiquée. S'il existe, cet enregistrement sera mis à jour. Sinon, un nouvel enregistrement sera créé{/t}</li>
                <li>{t}Pour conserver la clé primaire présente dans le fichier d'export, par exemple pour la mise à jour de tables de paramètres, il faut que le nom de la clé métier soit identique à la clé primaire{/t}</li>
                <li>{t}L'importation de tables de type n-n, c'est à dire dont la clé est composée de deux clés, chacune correspondante à une des deux tables de la relation, n'est possible qu'en mode ajout. Dans le cas contraire, l'importation échouera (tentative d'insertion d'un nouvel enregistrement de même clé). À noter que, dans le cas de tables n-n, le nom de la clé primaire ne doit pas être renseigné.{/t}</li>
                <li>{t}Dans le cas d'une relation de type 1-1, où une table fille partage la même clé que la table parente (cas des tables individual-individual_tracking dans Filo-Science), la table fille ne doit avoir que le nom de la clé étrangère renseignée{/t}</li>

            </ul>
        </div>
    </div>
</div>
<span class="red">*</span><span class="messagebas">{t}Donnée obligatoire{/t}</span>
