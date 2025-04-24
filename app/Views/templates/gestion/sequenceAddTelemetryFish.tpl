<script>
  $(document).ready(function () {
    $('#checkId').change(function() {
			$('.checkId').prop('checked', this.checked);
    })
  });
</script>
<div class="row">
	<div class="col-md-8">
		<a href="campaignDisplay&campaign_id={$data.campaign_id}">
			<img src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t}&nbsp;{$data.campaign_name}
		</a>
		&nbsp;

		<a href="operationDisplay&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}&activeTab=tab-sequence">
			<img src="display/images/display-green.png" height="25"> {t}Retour à l'opération{/t} &nbsp;{$data.operation_name}
		</a>
  &nbsp;
  <a href="sequenceDisplay&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}&sequence_id={$data.sequence_id}"><img src="display/images/display.png" height="25">{t}Retour à la séquence{/t}&nbsp;{$data.sequence_number} </a>
  </div>
</div>
<div class="row">
  <h2 class="col-sm-4">{t}Ajout de poissons saisis dans le module de télémétrie{/t}</h2>
</div>
  <form id="formAddFish" method="POST" action="index.php">
      <input type="hidden" name="module" value="sequenceAddTelemetryFishExec">
      <input type="hidden" name="sequence_id" value="{$data.sequence_id}">
      <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
      <input type="hidden" name="operation_id" value="{$data.operation_id}">
      <div class="row">
        <table class="table table-bordered table-hover datatable-nopaging display" data-order='[[2,"asc"],[3,"asc"]]'>
          <thead>
            <th class="center">
              <input type="checkbox" id="checkId" class="checkId" >
            </th>
            <th>{t}Id{/t}</th>
            <th>{t}Taxon{/t}</th>
            <th>{t}Code{/t}</th>
            <th>{t}standard{/t}</th>
            <th>{t}Fourche{/t}</th>
            <th>{t}Totale{/t}</th>
            <th>{t}Disque{/t}</th>
            <th>{t}Autre{/t}</th>
            <th>{t}Poids{/t}</th>
            <th>{t}Identifiant unique{/t}</th>
          </thead>
          <tbody>
            {foreach $individuals as $individual}
            <tr>
              <td class="center">
                <input type="checkbox" class="checkId" name="uids[]" value="{$individual.individual_id}" >
              </td>
              <td class="center">{$individual.individual_uid}</td>
              <td>{$individual.scientific_name}</td>
              <td class="center">{$individual.individual_code}</td>
              <td class="center">{$individual.sl}</td>
              <td class="center">{$individual.fl}</td>
              <td class="center">{$individual.tl}</td>
              <td class="center">{$individual.wd}</td>
              <td class="center">{$individual.ot}</td>
              <td class="center">{$individual.weight}</td>
              <td>{$individual.uuid}</td>
            </tr>
            {/foreach}
          </tbody>
        </table>
      </div>
      <div class="row">
        <div class="center">
            <button type="submit" class="btn btn-danger">{t}Associer les poissons sélectionnés à la séquence{/t}</button>
        </div>
      </div>
  {$csrf}</form>
</div>