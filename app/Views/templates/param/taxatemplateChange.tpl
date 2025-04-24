<script src="display/javascript/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
<script>
$(document).ready(function() { 
    $(".freshwater").on("change", function () {
        var freshwater = $(this).val();
        var url = "";
        var data = { "freshwater" : freshwater };
        $.ajax( {
            url: "taxonGetListCode",
            data: data
        })
        .done (function(data) {
            var result = JSON.parse(data);
            $("#source > tbody").empty();
            var col = 0;
            var content = "";
            for (var i = 0; i < result.length; i++) {
                if (col == 0) {
                    content += "<tr>";
                }
                content += '<td class="center"><div class="source" title="'+result[i].scientific_name+'">'+result[i].code+"</div></td>";
                col ++;
                if (col == 12) {
                    content += "</tr>";
                    col = 0;
                }
            }
            if (col != 0) {
                content += "</tr>";
            }
            $("#source > tbody").append(content);
            $(".source").draggable({
                cursor: "move",
                helper: "clone"
            });
        });
    });

    $(".source").draggable({
        revert: "invalid",
        cursor: "move",
        helper: "clone"
    });
    $(".dest").droppable({
        drop: function(event, ui ) {
            var content = $("input",ui.draggable).val();
            $("input",ui.draggable).val("");
            if (content === undefined) {
                content = ui.draggable.text();
                $(ui.draggable).addClass("blue");
            }            
            $("input", this).val(content);
        }
    });
    $(".dest").draggable({
        revert: "invalid",
        cursor: "move",
        helper: "clone"
    });
});

</script>

<h2>{t}Modification du modèle de grille de sélection des taxons n°{/t}&nbsp;<i>{$data.taxa_template_id}</i></h2>
<div class="row">
        <a href="taxatemplateList">
        <img src="display/images/list.png" height="25">
        {t}Retour à la liste{/t}
    </a>
</div>
<form  id="taxatemplatelist" method="post" action="taxatemplateWrite">
    <div class="row">
        <div class="col-md-4">
            <div class="form-horizontal ">
                <input type="hidden" name="moduleBase" value="taxatemplate">
                <input type="hidden" name="taxa_template_id" value="{$data.taxa_template_id}">
                <div class="form-group">
                    <label for="taxa_template_name"  class="control-label col-md-4"><span class="red">*</span> {t}Nom du modèle :{/t}</label>
                    <div class="col-md-8">
                        <input id="taxa_template_name" type="text" class="form-control" name="taxa_template_name" value="{$data.taxa_template_name}" autofocus required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="freshwater"  class="control-label col-md-4"> <span class="red">*</span>&nbsp;{t}Opération réalisée en eau douce ?{/t}</label>
                    <div class="col-md-8">
                            <label class="radio-inline">
                            <input  class="freshwater" type="radio" name="freshwater" id="freshwater1" value="1" {if $data.freshwater == 1}checked{/if}>
                            {t}oui{/t}
                        </label>
                        <label class="radio-inline">
                            <input  type="radio" class="freshwater" name="freshwater" id="freshwater2" value="0" {if $data.freshwater == 0}checked{/if}>
                            {t}non{/t}
                        </label>
                    </div>   
                </div>
                <div class="form-group center">
                    <button type="submit" class="btn btn-primary button-valid">{t}Valider{/t}</button>
                    {if $data.taxa_template_id > 0 }
                        <button class="btn btn-danger button-delete">{t}Supprimer{/t}</button>
                    {/if}
                </div>        
            </div>
        </div>
        <div class="col-md-8">
            <table id="grille" class="table">
                <thead>
                    <tr>
                        <th colspan="6">{t}Grille de sélection{/t}</th>
                    </tr>
                </thead>
                <tbody>
                    {for $line = 1 to 4}
                        <tr>
                            {for $column = 1 to 6}
                                <td class="center">
                                    <div class="dest">
                                    <input class="dest" name="grid{$line}-{$column}" value="{$grid[$line][$column]}" size="5">
                                    </div>
                                </td>
                            {/for}
                        </tr>
                    {/for}
                </tbody>
            </table>
        </div>


    </div>
    <div class="row">
        <div class="col-md-12">
            <table id="source" class="table " >
                <thead>
                    <tr><th colspan="12">{t}Codes disponibles{/t}</th></tr>
                </thead>
                <tbody>
                    {$col = 0}
                    {foreach $taxa as $taxon}
                        {if $col == 0}
                            <tr>
                        {/if}
                        <td class="center">
                            <div class="source" title="{$taxon.scientific_name}">{$taxon.code}</div>
                        </td>
                        {$col = $col + 1}
                        {if $col == 12}
                            </tr>
                            {$col = 0}
                        {/if}
                    {/foreach}
                    {if $col != 0}
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </div>
{$csrf}</form>