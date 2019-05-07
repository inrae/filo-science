<script>
$(document).ready(function() {
    /* select the current tab */
    var activeTab = "{$activeTab}";
    if (activeTab.length > 0) {
        //console.log(activeTab);
        $("#"+activeTab).tab('show');
    }
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
    </div>
</div>
