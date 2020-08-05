<script>
  $(document).ready(function () {
    $('#checkId').change(function() {
			$('.checkId').prop('checked', this.checked);
    }
  );
</script>
<div class="row">
	<div class="col-md-8">
		<a href="index.php?module=campaignDisplay&campaign_id={$data.campaign_id}">
			<img src="display/images/display-red.png" height="25">{t}Retour à la campagne{/t}&nbsp;{$data.campaign_name}
		</a>
		&nbsp;

		<a href="index.php?module=operationDisplay&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}&activeTab=tab-sequence">
			<img src="display/images/display-green.png" height="25"> {t}Retour à l'opération{/t} &nbsp;{$data.operation_name}
		</a>
  </div>
  &nbsp;
  <a href="index.php?module=sequenceDisplay&campaign_id={$data.campaign_id}&operation_id={$data.operation_id}&sequence_id={$data.sequence_id}"><img src="display/images/display.png" height="25">{t}Retour à la séquence{/t}&nbsp;{$data.sequence_number} </a>
{/if}
</div>
<div class="row">
  <h2 class="col-sm-4">{t}Ajout de poissons saisis dans le module de télémétrie{/t}</h2>
  <table class="table table-bordered table-hover datatable-nopaging" data-order='[[0,"desc"]]'>
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
					<input type="checkbox" class="checkId" name="uids[]" value="{$individual.individual_uid}" >
				</td>
        <td class="center">{$individual.individual_uid}</td>
        <td>{$individual.taxon_name}</td>
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