<h2>{t}Liste des modèles de mesures d'ambiances complémentaires{/t}</h2>
<div class="row">
  <div class="col-md-6">
    {if $droits.param == 1}
    <a href="index.php?module=ambienceTemplateChange&ambience_template_id=0">
      <img src="display/images/new.png" height="25">
      {t}Nouveau...{/t}
    </a>
    {/if}
    <table id="paramList" class="table table-bordered table-hover datatable-nopaging">
      <thead>
        <tr>
          <th>{t}Id{/t}</th>
          <th>{t}Nom{/t}</th>
        </tr>
      </thead>
      <tbody>
        {foreach $data as $row}
        <tr>
          <td class="center">{$row["ambience_template_id"]}</td>
          <td>
            {if $droits.param == 1}
            <a href="index.php?module=ambienceTemplateChange&ambience_template_id={$row.ambience_template_id}">
              {$row["ambience_template_name"]}
              {else}
              {$row["ambience_template_name"]}
              {/if}
          </td>
        </tr>
        {/foreach}
      </tbody>
    </table>
  </div>
</div>