<h2>{t}Opération{/t} {$data.operation_name}</h2>
<div class="row">
    <div class="col-md-12">
        <a href="index.php?module=campaignList"><img src="display/images/list.png" height="25">{t}Retour à la liste{/t}</a>
    </div>
    <nav>
        <div class="nav nav-tabs" id="nav-tab" role="tablist">
            <a class="nav-item nav-link active" id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab" aria-controls="nav-home" aria-selected="true">{t}Détails{/t}</a>
            <a class="nav-item nav-link" id="nav-ambience-tab" data-toggle="tab" href="#nav-ambience" role="tab" aria-controls="nav-ambience" aria-selected="false">{t}Ambiance générale{/t}</a>
            <a class="nav-item nav-link" id="nav-sequence-tab" data-toggle="tab" href="#nav-sequence" role="tab" aria-controls="nav-sequence" aria-selected="false">{t}Séquences{/t}</a>
        
        </div>
    </nav>

    <div class="tab-content" id="nav-tabContent">
        <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab">
            {include file="gestion/operationDetail.tpl"}
        </div>
        <div class="tab-pane fade" id="nav-ambience" role="tabpanel" aria-labelledby="nav-ambience-tab">
            {include file="gestion/ambienceDetail.tpl"}
        </div>
        <div class="tab-pane fade" id="nav-sequence" role="tabpanel" aria-labelledby="nav-sequence-tab">
            {include file="gestion/sequenceList.tpl"}
        </div>
    </div>
</div>