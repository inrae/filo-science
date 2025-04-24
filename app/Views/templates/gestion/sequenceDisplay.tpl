<script>
	$(document).ready(function () {
		$("#tab-ambience").on("shown.bs.tab", function () {
			if (typeof mapA !== "undefined") {
				setTimeout(function () { mapA.invalidateSize(); }, 400);
			}
		});

		/**
		 * set the id to the cookie
		 */
		Cookies.set('sequence_uid', "{$data.sequence_uid}", { expires: 7, secure: true });

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
			Cookies.set("tabHover", tabHover, { expires: 365, sameSite: "strict", secure: true });
		});
		var activeTab = "{$activeTab}";
		if (activeTab.length == 0) {
			try {
				activeTab = Cookies.get("sequenceDisplayTab");
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
			Cookies.set("sequenceDisplayTab", $(this).attr("id"), { sameSite: "strict", secure: true});
		});
		$('a[data-toggle="tab"]').on("click", function () {
			tabHover = 0;
		});
		$('a[data-toggle="tab"]').on("click", function () {
			survol = false ;
		});
    $("#seq_duplicate").submit( function (event) {
      if (! confirm("{t}Confirmez-vous la duplication de la séquence ?{/t}")){
        event.preventDefault();
      }
    });
	});
</script>


<div class="row">
	<div class="col-md-8">
		<a href="campaignDisplay?campaign_id={$data.campaign_id}">
			<img src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t}&nbsp;{$data.campaign_name}
		</a>
		&nbsp;

		<a href="operationDisplay?campaign_id={$data.campaign_id}&operation_id={$data.operation_id}&activeTab=tab-sequence">
			<img src="display/images/display-green.png" height="25"> {t}Retour à l'opération{/t} &nbsp;{$data.operation_name}
		</a>
	</div>
</div>
<div class="row">
	<h2 class="col-sm-4">{t}Séquence{/t}&nbsp;{$data.sequence_number}</h2>
  <div class="col-sm-2 col-sm-offset-2">
		<form id="seq_duplicate" method="POST" action="sequenceDuplicate">
      <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
      <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
      <input type="hidden" name="operation_id" value="{$data.operation_id}">
      <button type="submit" class="btn btn-warning">{t}Dupliquer la séquence{/t}</button>
		{$csrf}</form>
	</div>
	<div class="col-sm-2 ">
		<form id="seq_attach" method="POST" action="sequenceAddTelemetryFish">
      <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
      <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
      <input type="hidden" name="operation_id" value="{$data.operation_id}">
      <button type="submit" class="btn btn-info">{t}Ajouter des poissons saisis dans le module de télémétrie{/t}</button>
		{$csrf}</form>
	</div>
</div>
<div class="row">
	<ul class="nav nav-tabs" id="myTab" role="tablist">
		<li class="nav-item active">
			<a class="nav-link" id="tab-detail" data-toggle="tab" role="tab" aria-controls="nav-detail"
				aria-selected="true" href="#nav-detail">{t}Détails{/t}</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" id="tab-sample" href="#nav-sample" data-toggle="tab" role="tab"
				aria-controls="nav-sample" aria-selected="false">{t}Échantillons{/t}</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" id="tab-ambience" href="#nav-ambience" data-toggle="tab" role="tab"
				aria-controls="nav-ambience" aria-selected="false">{t}Ambiance{/t}</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" id="tab-gear" href="#nav-gear" data-toggle="tab" role="tab" aria-controls="nav-gear"
				aria-selected="false">{t}Engins de pêche{/t}</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" id="tab-analysis" href="#nav-analysis" data-toggle="tab" role="tab"
				aria-controls="nav-analysis" aria-selected="false">{t}Analyse d'eau{/t}</a>
		</li>
		<li class="nav-item">
				<a class="nav-link" id="tab-point" href="#nav-point" data-toggle="tab" role="tab" aria-controls="nav-point" aria-selected="false">{t}Points d'échantillonnage{/t}</a>
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
		<div class="tab-pane fade" id="nav-point" role="tabpanel" aria-labelledby="tab-sequence">
				<div class="col-md-12">
					{include file="gestion/sequencePointList.tpl"}
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
