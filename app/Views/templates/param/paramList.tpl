<h2>{t}Liste des paramètres : {/t}{$tabledescription}</h2>
<div class="row">
	<div class="col-md-6">
		{if $rights.param == 1}
		<a href="{$tablename}Change&{$tablename}_id=0">
			<img src="display/images/new.png" height="25">
			{t}Nouveau...{/t}
		</a>
		{/if}
		<table id="paramList" class="table table-bordered table-hover datatable ">
			<thead>
				<tr>
					<th>{t}Id{/t}</th>
					<th>{t}Libellé{/t}</th>
					<th>{t}Code métier{/t}</th>
				</tr>
			</thead>
			<tbody>
				{foreach $data as $row}
				<tr>
					<td class="center">{$row[$fieldid]}</td>
					<td>
						{if $rights.param == 1}
						<a href="{$tablename}Change&{$tablename}_id={$row[$fieldid]}">
							{$row[$fieldname]}
						</a>
						{else}
						{$row[$fieldname]}
						{/if}
					</td>
					<td>{$row[$fieldcode]}</td>
				</tr>
				{/foreach}
			</tbody>
		</table>
	</div>
</div>