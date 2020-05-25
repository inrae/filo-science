<script>
    $(document).ready(function () {
        $("#tab-detail").on("shown.bs.tab", function () {
            setTimeout(function () { map.invalidateSize(); }, 400);
        });
        $("#tab-ambience").on("shown.bs.tab", function () {
            setTimeout(function () { mapA.invalidateSize(); }, 400);
        });
        $("#tab-sequence").on("shown.bs.tab", function () {
            setTimeout(function () { mapS.invalidateSize(); }, 400);
        });


        Cookies.set('operation_uid', "{$data.operation_uid}", { expires: 7, secure: true });

        /**
         * Tab management
         */
        var tabHover = 0;
        try {
            tabHover = Cookies.get("tabHover");
        } catch (Exception) { }
        if (tabHover == 1) {
            $("#tabHoverSelect").prop("checked", true);
        }
        $("#tabHoverSelect").change(function () {
            if ($(this).is(":checked")) {
                tabHover = 1;
            } else {
                tabHover = 0;
            }
            Cookies.set("tabHover", tabHover, { expires: 365 });
        });
        /* Management of tabs */
        var activeTab = "{$activeTab}";
        if (activeTab.length == 0) {
            try {
                activeTab = Cookies.get("operationDisplayTab");
            } catch (Exception) {
                activeTab = "";
            }
        }
        try {
            if (activeTab.length > 0) {
                $("#" + activeTab).tab('show');
            }
        } catch (Exception) { }
        $('.nav-tabs > li > a').hover(function () {
            if (tabHover == 1) {
                $(this).tab('show');
            }
        });
        $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
            Cookies.set("operationDisplayTab", $(this).attr("id"));
        });
        $('a[data-toggle="tab"]').on("click", function () {
            tabHover = 0;
        });
        $("#duplicate").submit(function(event) {
            if (! confirm( "{t}Confirmez-vous la duplication de l'opération courante ?{/t}")) {
                event.preventDefault();
            }
        });
    });
</script>
<div class="row">
     <div class="col-md-8">
            <a href="index.php?module=campaignDisplay&campaign_id={$data.campaign_id}"><img
                    src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t} {$data.campaign_name}</a>
        </div>

</div>
<div class="row">
    <h2 class="col-sm-8">{t}Opération{/t} {$data.operation_name}</h2>
    <div class="col-sm-2 col-sm-offset-2">
        {if $droits.gestion == 1}
            <form id="duplicate" method="post" action="index.php">
                <input type="hidden" name="moduleBase" value="operation">
                <input type="hidden" name="action" value="Duplicate">
                <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
                <input type="hidden" name="operation_id" value="{$data.operation_id}">
                <button type="submit" class="btn btn-warning">Dupliquer</button>
            </form>
        {/if}
    </div>
</div>

<div class="row">
    <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item active">
            <a class="nav-link" id="tab-detail" data-toggle="tab" role="tab" aria-controls="nav-detail"
                aria-selected="true" href="#nav-detail">{t}Détails{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-ambience" href="#nav-ambience" data-toggle="tab" role="tab"
                aria-controls="nav-ambience" aria-selected="false">{t}Ambiance générale{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-sequence" href="#nav-sequence" data-toggle="tab" role="tab"
                aria-controls="nav-sequence" aria-selected="false">{t}Séquences de pêche{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-operator" href="#nav-operator" data-toggle="tab" role="tab"
                aria-controls="nav-operator" aria-selected="false">{t}Opérateurs{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-document" href="#nav-document" data-toggle="tab" role="tab"
                aria-controls="nav-document" aria-selected="false">{t}Documents{/t}</a>
        </li>
    </ul>
    <div class="tab-content" id="nav-tabContent">
        <div class="tab-pane active in" id="nav-detail" role="tabpanel" aria-labelledby="tab-detail">
            <div class="col-md-12">
                {include file="gestion/operationDetail.tpl"}
            </div>
        </div>
        <div class="tab-pane fade" id="nav-ambience" role="tabpanel" aria-labelledby="tab-ambience">
            <div class="col-md-12">
                {include file="gestion/ambienceDetailOperation.tpl"}
            </div>
        </div>
        <div class="tab-pane fade" id="nav-sequence" role="tabpanel" aria-labelledby="tab-sequence">
            <div class="col-md-12">
                {include file="gestion/sequenceList.tpl"}
            </div>
        </div>
        <div class="tab-pane fade" id="nav-operator" role="tabpanel" aria-labelledby="tab-operator">
            <div class="col-md-12">
                {include file="gestion/operationOperators.tpl"}
            </div>
        </div>
        <div class="tab-pane fade" id="nav-document" role="tabpanel" aria-labelledby="tab-document">
            <div class="col-md-12">
                {include file="gestion/documentList.tpl"}
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-sm-12 messageBas">
        {t}Activer le survol des onglets :{/t}
        <input type="checkbox" id="tabHoverSelect">
    </div>
</div>
