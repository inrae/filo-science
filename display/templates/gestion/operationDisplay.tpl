<script>
$(document).ready(function() {
    /* Management of tabs */
    var activeTab = "{$activeTab}";
    var survol = true;
    if (activeTab.length == 0) {
        try {
        activeTab = Cookies.get("operationDisplayTab");
        } catch (Exception) {
            activeTab = "";
        }
    }
    try {
        if (activeTab.length > 0) {
            $("#"+activeTab).tab('show');
        } 
    } catch (Exception) { }
    $('.nav-tabs > li > a').hover(function() {
        if (survol) {
            $(this).tab('show');
        }
    });
        $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
        Cookies.set("operationDisplayTab",$(this).attr("id"));
    });
    $('a[data-toggle="tab"]').on("click", function () {
        survol = false ;
    });
    $("#tab-ambience").on ("shown.bs.tab", function() { 
        setTimeout( function() { mapAmbience.updateSize();}, 200);
    });
    

    /**
     * set the id to the cookie
     */
     Cookies.set('operation_uid', "{$data.operation_uid}", { expires: 1, secure: true, sameSite="strict"});
});

</script>
<h2>{t}Opération{/t} {$data.operation_name}</h2>
<div class="row">
    <div class="col-md-12">
        <a href="index.php?module=campaignDisplay&campaign_id={$data.campaign_id}"><img src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t}</a>
    </div>

    <ul class="nav nav-tabs" id="myTab" role="tablist" >
        <li class="nav-item active">
            <a class="nav-link" id="tab-detail" data-toggle="tab"  role="tab" aria-controls="nav-detail" aria-selected="true" href="#nav-detail">{t}Détails{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-ambience" href="#nav-ambience"  data-toggle="tab" role="tab" aria-controls="nav-ambience" aria-selected="false">{t}Ambiance générale{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-sequence" href="#nav-sequence"  data-toggle="tab" role="tab" aria-controls="nav-sequence" aria-selected="false">{t}Séquences de pêche{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-operator" href="#nav-operator" data-toggle="tab" role="tab" aria-controls="nav-operator" aria-selected="false">{t}Opérateurs{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-document" href="#nav-document" data-toggle="tab" role="tab" aria-controls="nav-document" aria-selected="false">{t}Documents{/t}</a>
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
