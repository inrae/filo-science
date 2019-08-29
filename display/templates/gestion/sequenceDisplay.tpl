<script>
$(document).ready(function() {
    /* Management of tabs */
    var activeTab = "{$activeTab}";
    var survol = true;
    if (activeTab.length == 0) {
        try {
        activeTab = Cookies.get("sequenceDisplayTab");
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
        Cookies.set("sequenceDisplayTab",$(this).attr("id"));
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
     Cookies.set('sequence_uid', "{$data.sequence_uid}", { expires: 1, secure: true});
});

</script>

<h2>{t}Séquence{/t}&nbsp;{$data.sequence_number}</h2>
<div class="row">
    <div class="col-md-12">
        <a href="index.php?module=campaignDisplay&campaign_id={$data.campaign_id}"><img src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t}&nbsp;{$data.campaign_name}</a>
        &nbsp;

        <a href="index.php?module=operationDisplay&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}&activeTab=tab-sequence">
                <img src="display/images/display-green.png" height="25">   {t}Retour à l'opération{/t} {$data.operation_name}</a>
    </div>

    <ul class="nav nav-tabs" id="myTab" role="tablist" >
        <li class="nav-item active">
            <a class="nav-link" id="tab-detail" data-toggle="tab"  role="tab" aria-controls="nav-detail" aria-selected="true" href="#nav-detail">{t}Détails{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-sample" href="#nav-sample"  data-toggle="tab" role="tab" aria-controls="nav-sample" aria-selected="false">{t}Échantillons{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-ambience" href="#nav-ambience"  data-toggle="tab" role="tab" aria-controls="nav-ambience" aria-selected="false">{t}Ambiance{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-gear" href="#nav-gear"  data-toggle="tab" role="tab" aria-controls="nav-gear" aria-selected="false">{t}Engins de pêche{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-analysis" href="#nav-analysis"  data-toggle="tab" role="tab" aria-controls="nav-analysis" aria-selected="false">{t}Analyse d'eau{/t}</a>
        </li>
    </ul>
    <div class="tab-content" id="nav-tabContent">
        <div class="tab-pane active in" id="nav-detail" role="tabpanel" aria-labelledby="tab-detail">
           <div class="col-md-12">
                {include file="gestion/sequenceDetail.tpl"}
            </div>
        </div>
        <div class="tab-pane fade" id="nav-ambience" role="tabpanel" aria-labelledby="tab-ambience">
            <div class="col-md-12">
                {include file="gestion/ambienceDetailSequence.tpl"}
            </div>
        </div>
        <div class="tab-pane fade" id="nav-sample" role="tabpanel" aria-labelledby="tab-sequence">
            <div class="col-md-12">
                {include file="gestion/sampleList.tpl"}
            </div>
        </div>
        <div class="tab-pane fade" id="nav-gear" role="tabpanel" aria-labelledby="tab-sequence">
            <div class="col-md-12">
                {include file="gestion/gearList.tpl"}
            </div>
        </div>
        <div class="tab-pane fade" id="nav-analysis" role="tabpanel" aria-labelledby="tab-sequence">
            <div class="col-md-12">
                {include file="gestion/analysisDetail.tpl"}
            </div>
        </div>

    </div>
</div>