<script>
	$(document).ready(function () {
		var projectId = "{$projects[0].project_id}";
		try {
			var projectIdCookie = Cookies.get("projectId");
		} catch {
			Cookies.set("projectId", projectId, { expires: 180, secure: true });
		}
		if (projectIdCookie ) {
			projectId = projectIdCookie;
		} else {
			Cookies.set("projectId", projectId, { expires: 180, secure: true });
		}
		var projectActive = 1;
		try {
			projectActive = Cookies.get("projectActive");
		} catch { }
		$("#projectActive" + projectActive).attr("checked", "true");
		$("#project" + projectId).attr("selected", true);
		var year = "{$year}";
		try {
			if (year.length < 4) {
				year = Cookies.get("year");
			}
		}catch { }
		$("#year").change(function () {
			Cookies.set("year", $(this).val(), { expires: 180, secure: true });
		});
		$("#year" + year).attr("selected", true);
		var taxon_id = "{$taxon_id}";
		try {
			if (taxon_id == 0) {
				taxon_id = Cookies.get("taxon_id");
			}
		}catch { }
		$("#taxon_id" + taxon_id).attr("selected", true);
		$("#taxon_id").change(function () {
			Cookies.set("taxon_id", $(this).val(), { expires: 180, secure: true });
		});
		var delay = "{$delay}";
		try {
			if (delay == 0) {
				delay = Cookies.get("delay");
			}
		}catch { }
		$("#delay").val(delay);
		$("#delay").change(function () {
			Cookies.set("delay", $(this).val(), { expires: 180, secure: true });
		});

		$("#new").attr("href", "individualTrackingChange?individual_id=0&project_id="+projectId);
		$(".is_active").change(function () {
			$("#project_id").val("");
			Cookies.set("projectActive", $(this).val(), { expires: 180, secure: true });
			$("#individualTrackingSearch").submit();
		});
		$("#project_id").change(function () {
			//Cookies.set("projectId", $(this).val(), { expires: 180, secure: true });
			$("#individualTrackingSearch").submit();
		});
		$("#checkId").change(function(){
			$(".checkId").prop('checked', this.checked);
		});
		$("#exportDetection").on ("keypress click", function(event) {
			$("#module").val("individualTrackingExport");
			$(this.form).prop('target', '_self').submit();
		});
		$("#individualTrackingSearch").submit(function(event) {
			var pj = $("#project_id").val();
			if (pj == null) {
				pj = 0;
			}
			Cookies.set("projectId", pj , { expires: 180, secure: true });
		});

		/* offset for display detections */
		var offset = "{$offset}";
		$("#offset0").click(function () {
			offset = parseInt( offset) - 100;
			if (offset < 0) {
				offset = 0;
			}
			$("#offset").val(offset);
			$("#detectionListForm").submit();
		});
		$("#offset1").click(function () {
			offset = parseInt(offset) + 100;
			$("#offset").val(offset);
			$("#detectionListForm").submit();
		});

		/* Tab Management */
    documentName = "operationDisplayTab";
    activeTab = "";
    try {
      activeTab = Cookies.get(documentName);
    } catch (Exception) {
      activeTab = "";
    }
    try {
      if (activeTab.length > 0) {
        $("#" + activeTab).tab('show');
      }
    } catch (Exception) { }
    $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
      Cookies.set(documentName, $(this).attr("id"), { sameSite: "strict", secure: true});
		});
		$("#tab-map").on("shown.bs.tab", function () {
			setTimeout(function () {
				 map.invalidateSize();
				}, 400);
				display();
		});
	});
</script>
<h2>{t}Liste des poissons suivis{/t}</h2>
<div class="row">
	{if $rights.manage == 1}
		<a id="new" href="individualTrackingChange?individual_id=0">
			<img src="display/images/new.png" height="25">
			{t}Nouveau...{/t}
		</a>
	{/if}
</div>
<div class="row">
	<div class="col-lg-8 col-md-12">
		<form class="form-horizontal " id="individualTrackingSearch" action="individualTrackingList" method="GET">
			<input id="isSearch" type="hidden" name="isSearch" value="1">
			<div class="form-group">
				<label for="project_id" class="col-md-2 control-label">{t}Projet :{/t}</label>
				<div class="col-md-3">
					<select id="project_id" name="project_id" class="form-control">
						{foreach $projects as $row}
						<option id="project{$row.project_id}" value="{$row.project_id}" {if $row.project_id == $project_id}selected{/if}>
							{$row.project_name}
						</option>
						{/foreach}
					</select>
				</div>
				<label for="is_active" class="col-md-2 control-label">{t}actifs ?{/t}</label>
				<div class="col-md-2">
					<input type="radio" class="is_active" id="projectActive1" name="is_active" value="1" {if $is_active == 1}checked{/if}>{t}oui{/t}
					<input type="radio" class="is_active" id="projectActive0" name="is_active" value="0"{if $is_active == 0}checked{/if}>{t}non{/t}
				</div>
				<div class="col-md-2">
					<input type="submit" class="btn btn-success" value="{t}Rechercher{/t}">
				</div>
			</div>
			<div class="form-group">
				<label for="year" class="col-md-2 control-label">{t}Année :{/t}</label>
				<div class="col-md-1">
					<select id="year" name="year" class="form-control">
						<option id="year0" value="0" {if $year == 0} selected{/if}>{t}Choisissez...{/t}</option>
						{foreach $years as $y}
						<option id="year{$y.year}" value="{$y.year}" {if $y.year == $year}selected{/if}>{$y.year}</option>
						{/foreach}
					</select>
				</div>
				<label for="taxon_id" class="col-md-1 control-label">{t}Espèce : {/t}</label>
				<div class="col-md-3">
					<select id="taxon_id" name="taxon_id" class="form-control">
						<option id="taxon_id0" value="0" {if $taxon_id == 0} selected{/if}>{t}Choisissez...{/t}</option>
						{foreach $taxa as $taxon}
						<option id="taxon_id{$taxon.taxon_id}" value="{$taxon.taxon_id}" {if $taxon.taxon_id == $taxon_id}selected{/if}>{$taxon.scientific_name}</option>
						{/foreach}
					</select>
				</div>
				<label for="delay" class="col-md-2 control-label">{t}Intervalle (en secondes) de regroupement des détections :{/t}</label>
				<div class="col-md-2">
					<input name="delay" id="delay" value="{$delay}" placeholder="3600" class="nombre form-control">
				</div>
			</div>
		{$csrf}</form>
	</div>
</div>

<ul class="nav nav-tabs" id="myTab" role="tablist">
  <li class="nav-item active">
    <a class="nav-link" id="tab-list" data-toggle="tab" role="tab" aria-controls="nav-list" aria-selected="true"
      href="#nav-list">{t}Liste{/t}</a>
	</li>
	{if $selectedIndividual > 0}
  <li class="nav-item">
    <a class="nav-link" id="tab-detection" href="#nav-detection" data-toggle="tab" role="tab" aria-controls="nav-detection"
      aria-selected="false">{t}Détections{/t}&nbsp;{$individual.individual_id}&nbsp;<i>{$individual.scientific_name}</i>&nbsp;{$individual.individual_code}</a>
	</li>
	<li class="nav-item">
		<a class="nav-link" id="tab-detaildetection" href="#nav-detaildetection" data-toggle="tab" role="tab" aria-controls="nav-detaildetection"
      aria-selected="false">{t}Récapitulatif journalier{/t}</a>
	</li>
	<li class="nav-item">
		<a class="nav-link" id="tab-recapstation" href="#nav-recapstation" data-toggle="tab" role="tab" aria-controls="nav-recapstation" aria-selected="false">{t}Récapitulatif par station{/t}</a>
	</li>
	<li class="nav-item">
		<a class="nav-link" id="tab-map" href="#nav-map" data-toggle="tab" role="tab" aria-controls="nav-detection"
		aria-selected="false">{t}Carte des détections par station{/t}</a>
	</li>
	{/if}
</ul>
<div class="tab-content" id="nav-tabContent">
  <div class="tab-pane active in" id="nav-list" role="tabpanel" aria-labelledby="tab-list">
	<div class="col-md-12 col-lg-8">
		<form id="findividualList" method="POST" action="individualTrackingList">
			<input type="hidden" name="project_id" value="{$project_id}">
			<div class="row">
				<button id="exportDetection" class="btn btn-info">{t}Exporter les détections{/t}</button>
			</div>
			<table id="individualList" class="table table-bordered table-hover datatable-searching " data-order = '[[2,"asc"]]'>
				<thead>
					<tr>
						<th class="center">
							<input type="checkbox" id="checkId" class="checkId" checked>
						</th>
						<th>{t}Détections{/t}</th>
						<th>{t}Id{/t}</th>
						<th>{t}Taxon{/t}</th>
						<th>{t}Code{/t}</th>
						<th>{t}Tag RFID{/t}</th>
						<th>{t}Émetteur acoustique ou radio{/t}</th>
						<th>{t}Modèle d'émetteur{/t}</th>
						<th>{t}Marque spaghetti{/t}</th>
						<th>{t}Année(s){/t}</th>
						<th>{t}Identifiant unique{/t}</th>
						<th>{t}Nombre de détections{/t}</th>
						{if $rights.manage == 1}
							<th class="center" title="{t}Modifier{/t}"><img src="display/images/edit.gif" height="25"></th>
						{/if}
					</tr>
				</thead>
				<tbody>
					{foreach $individuals as $individual}
					<tr>
						<td class="center">
							<input type="checkbox" class="checkId" name="uids[]" value="{$individual.individual_id}" checked>
						</td>
						<td class="center {if $individual.individual_id == $selectedIndividual}itemSelected{/if}">
							<a href="individualTrackingList?individual_id={$individual.individual_id}">
									<img src="display/images/result.png" height="25">
								</a>
					</td>
						<td class="center">
								{$individual.individual_id}
						</td>
						<td>{$individual.scientific_name}</td>
						<td>{$individual.individual_code}</td>
						<td>{$individual.tag}</td>
						<td>{$individual.transmitter}</td>
						<td>{$individual.transmitter_type_name}</td>
						<td>{$individual.spaghetti_brand}</td>
						<td>{$individual.year}</td>
						<td>{$individual.uuid}</td>
						<td class="right">{$individual.nb_detections}</td>
						{if $rights.manage == 1}
						<td class="center" title="{t}Modifier{/t}">
							<a href="individualTrackingChange?individual_id={$individual.individual_id}&project_id={$individual.project_id}">
								<img src="display/images/edit.gif" height="25">
							</a>
							</td>
							{/if}
					</tr>
					{/foreach}
				</tbody>
			</table>
		{$csrf}</form>
	</div>
	</div>
	{if $selectedIndividual > 0}
	<div class="tab-pane fade" id="nav-detection" role="tabpanel" aria-labelledby="tab-detection">
		<fieldset class="col-lg-12">
			<legend>{t}Liste des détections{/t}</legend>
			<a href="locationChange?location_id=0&individual_id={$selectedIndividual}">
				{t}Nouvelle détection manuelle{/t}
			</a>
			{if count($detections) > 0}
			<form id="detectionListForm" method="GET" action="individualTrackingList">
				<input type="hidden" name="project_id" value="{$project_id}">
				<input type="hidden" name="individual_id" id="individual_id2" value="{$individual.individual_id}">
				<input type="hidden" name="selectedIndividual" value="{$individual.individual_id}">

					<table id="detectionList" class="table table-bordered table-hover datatable display" data-order='[[ 1,"asc"],[0,"asc"]]'>
						<thead>
							<tr>
								<td>
									<button id="offset0" class="btn btn-secondary">{t}Précédent{/t}</button>
								</td>
								<td colspan="9">
									{t}Aller à la ligne :{/t}&nbsp;
									<input name="offset" id="offset" value="{$offset}">
									<button type="submit" class="btn btn-primary">{t}Rechercher{/t}</button>
								</td>
								<td >
									<button id="offset1" class="btn btn-secondary">{t}Suivant{/t}</button>
								</td>
							</tr>
							<tr>
								<th>{t}Id{/t}</th>
								<th>{t}Date/heure de détection{/t}</th>
								<th>{t}Type de détection{/t}</th>
								<th>{t}Station{/t}</th>
								<th>{t}Nbre d'événements{/t}</th>
								<th>{t}Durée, en secondes{/t}</th>
								<th>{t}Force du signal{/t}</th>
								<th>{t}Longitude{/t}</th>
								<th>{t}Latitude{/t}</th>
								<th>{t}Observation{/t}</th>
								<th>{t}Valide ?{/t}</th>
							</tr>
						</thead>
						<tbody>
							{foreach $detections as $detection}
								<tr>
									<td class="center">
										{if $rights.manage == 1}
											{if $detection.detection_type == "stationary"}
												<a href="detectionChange?detection_id={$detection.id}&individual_id={$detection.individual_id}">
												{else}
												<a href="locationChange?location_id={$detection.id}&individual_id={$detection.individual_id}">
											{/if}
											{$detection.id}
											</a>
										{else}
											{$detection.id}
										{/if}
									</td>
									<td>{$detection.detection_date}</td>
									<td>
										{if $detection.detection_type == "stationary"}
											{t}Station fixe{/t}
										{else}
											{t}Détection mobile{/t}
										{/if}
									</td>
									<td>{$detection.station_name} {$detection.antenna_code}</td>
									<td class="center">{$detection.nb_events}</td>
									<td class="center">{$detection.duration}</td>
									<td class="right">{$detection.signal_force}</td>
									<td class="right">{$detection.long}</td>
									<td class="right">{$detection.lat}</td>
									<td class="textareaDisplay">{$detection.observation}</td>
									<td class="center">
										{if $detection.validity == 1}{t}oui{/t}{else}<span class="red">{t}non{/t}</span>{/if}
									</td>
								</tr>
							{/foreach}
						</tbody>
					</table>
				{$csrf}</form>
			{/if}
		</fieldset>
	</div>
	<div class="tab-pane fade" id="nav-detaildetection" role="tabpanel" aria-labelledby="tab-detaildetection">
		<div class="col-lg-8">
			<table id="dailyDetection" class="table table-bordered table-hover datatable-export-paging display">
				<thead>
					<tr>
						<th>{t}Date{/t}</th>
						<th>{t}Jour{/t}</th>
						<th>{t}Nuit{/t}</th>
						<th>{t}Non déterminé{/t}</th>
						<th>{t}Total{/t}</th>
					</tr>
				</thead>
				<tbody>
					{$total_n = 0}
					{$total_d = 0}
					{$total_u = 0}
					{foreach $detection_number as $dn}
						<tr>
							<td>{$dn.detection_date}</td>
							<td class="right">{if $dn.day > 0}{$dn.day}{/if}</td>
							<td class="right">{if $dn.night > 0}{$dn.night}{/if}</td>
							<td class="right">{if $dn.unknown > 0}{$dn.unknown}{/if}</td>
							<td class="right">{$dn.day + $dn.night + $dn.unknown}</td>
						</tr>
						{$total_n = $total_n + $dn.night}
						{$total_d = $total_d + $dn.day}
						{$total_u = $total_u + $dn.unknown}
					{/foreach}
				</tbody>
				<tfoot>
					<tr>
						<td >{t}Total général :{/t}</td>
						<td class="right">{$total_d}</td>
						<td class="right">{$total_n}</td>
						<td class="right">{$total_u}</td>
						<td class="right">{$total_d + $total_n + $total_u}</td>
					</tr>
				</tfoot>
			</table>
		</div>

	</div>
	<div class="tab-pane fade" id="nav-recapstation" role="tabpanel" aria-labelledby="tab-recapstation">
		<div class="col-lg-12">
			<table id="stationDetection" class="table table-bordered table-hover datatable-export-paging display" data-order='[[4,"asc"]]'>
				<thead>
					<tr>
						<th>{t}Station{/t}</th>
						<th>{t}Antenne{/t}</th>
						<th>{t}N° station{/t}</th>
						<th>{t}Code station{/t}</th>
						<th>{t}Début{/t}</th>
						<th>{t}Fin{/t}</th>
						<th>{t}Nombre d'événements{/t}</th>
					</tr>
				</thead>
				<tbody>
					{foreach $stationDetection as $row}
						<tr>
							<td>{$row.station_name}</td>
							<td>{$row.antenna_code}</td>
							<td class="center">{$row.station_number}</td>
							<td class="center">{$row.station_code}</td>
							<td>{$row.date_from}</td>
							<td>{$row.date_to}</td>
							<td class="right">{$row.nb_events}</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
		<div class="col-lg-12">
			{include file="tracking/individualTrackingGraph.tpl"}
		</div>
	</div>
	<div class="tab-pane fade" id="nav-map" role="tabpanel" aria-labelledby="tab-map">
		<div class="row">
			<div class="col-md-12">
				{include file="tracking/individualTrackingMap.tpl"}
			</div>
		</div>
	</div>
	{/if}
</div>
