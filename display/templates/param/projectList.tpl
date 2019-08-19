<h2>{t}Liste des projets{/t}</h2>
<div class="row">
	<div class="col-md-6">
		{if $droits.param == 1}
			<a href="index.php?module=projectChange&project_id=0">
				<img src="display/images/new.png" height="25">
				{t}Nouveau...{/t}
			</a>
		{/if}
		<table id="projectList" class="table table-bordered table-hover datatable " >
			<thead>
				<tr>
					<th>{t}Nom du projet{/t}</th>
					<th>{t}Id{/t}</th>
					<th>{t}Groupes de login autorisés{/t}</th>
					{if $droits.param == 1}
						<th class="center">
							<img src="display/images/edit.gif" height="25">
						</th>
					{/if}
				</tr>
			</thead>
			<tbody>
				{section name=lst loop=$data}
					<tr>
						<td>
							<a href="index.php?module=projectDisplay&project_id={$data[lst].project_id}">
								{$data[lst].project_name}
							</a>
						</td>
						<td class="center">{$data[lst].project_id}</td>
						<td>{$data[lst].groupe}</td>
						{if $droits.param == 1}
							<td class="center">
								<a href="index.php?module=projectChange&project_id={$data[lst].project_id}" title="{t}Modifier{/t}">
									<img src="display/images/edit.gif" height="25">
								</a>
							</td>
						{/if}
					</tr>
				{/section}
			</tbody>
		</table>
	</div>
</div>