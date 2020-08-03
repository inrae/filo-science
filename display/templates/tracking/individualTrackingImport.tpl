<!-- Displaying found errors -->
{if $error == 1}
  <div class="row">
    <div class="col-md-12">
      <table id="containerList" class="table table-bordered table-hover datatable " >
        <thead>
          <tr>
            <th>{t}N° de ligne{/t}</th>
            <th>{t}Anomalie(s) détectée(s){/t}</th>
          </tr>
        </thead>
        <tbody>
          {foreach $errors as $err}
            <tr>
              <td class="center">{$err.lineNumber}</td>
              <td>{$err.content}</td>
            </tr>
          {/foreach}
        </tbody>
      </table>
    </div>
  </div>
  </div>
{/if}
<div class="row">
  <div class="col-md-6">
    <form class="form-horizontal protoform" id="importForm" method="post" action="index.php"
      enctype="multipart/form-data">
      <input type="hidden" name="module" value="individualTrackingImportExec">
      <div class="form-group">
        <label for="FileName" class="control-label col-md-4">
          <span class="red">*</span> {t}Fichier à importer :{/t}
        </label>
        <div class="col-md-8">
          <input id="FileName" type="file" class="form-control" name="filename" size="40" required>
        </div>
      </div>
      <div class="form-group">
        <label for="project_id" class="col-md-4 control-label">{t}Projet :{/t}</label>
        <div class="col-md-8">
          <select id="project_id" name="project_id" class="form-control">
            {foreach $projects as $project}
            <option id="project{$project.project_id}" value="{$project.project_id}">
              {$project.project_name}
            </option>
            {/foreach}
          </select>
        </div>
      </div>
      <div class="form-group">
        <label for="separator" class="control-label col-md-4">
          <span class="red">*</span> {t}Séparateur de champs :{/t}
        </label>
        <div class="col-md-8">
          <select id="separator" name="separator" class="form-control">
            <option value=";" {if $data.separator==";" }selected{/if}> {t}point-virgule{/t} </option>
            <option value="," {if $data.separator=="," }selected{/if}> {t}virgule{/t} </option>
            <option value="tab" {if $data.separator=="tab" }selected{/if}> {t}tabulation{/t} </option>
            <option value="space" {if $data.separator=="space" }selected{/if}> {t}espace{/t} </option>
          </select>
        </div>
      </div>
      <div class="form-group center">
          <button type="submit" class="btn btn-primary button-danger">{t}Déclencher l'import{/t}</button>
      </div>
    </form>
  </div>




  <div class="col-md-6 bg-info">
    {t}Ce module permet d'importer des poissons utilisés en télémétrie.{/t}
    <br>
    {t}Il n'accepte que des fichiers au format CSV. La ligne d'entête doit comprendre exclusivement les colonnes suivantes (toutes les colonnes peuvent ne pas être présentes, sauf la colonne taxon_id, obligatoire) :{/t}
    <br>
    <ul>
      <li><b>taxon_id</b>{t} (obligatoire) : identifiant du taxon (voir la table correspondante dans les paramètres){/t}</li>
      <li><b>individual_code</b>{t} : code métier (code attribué pour l'expérimentation en cours){/t}</li>
      <li><b>tag</b>{t} : code du tag radio{/t}</li>
      <li><b>transmitter</b>{t} : code du transmetteur acoustique{/t}</li>
      <li><b>spaghetti_brand</b>{t} : marque spaghetti{/t}</li>
      <li><b>uuid</b>{t} : code UUID permettant d'identifier de manière unique le poisson{/t}</li>
      <li><b>sl</b>{t} : longueur standard (mm){/t}</li>
      <li><b>fl</b>{t} : longueur à la fourche (mm){/t}</li>
      <li><b>wd</b>{t} : diamètre du disque (mm){/t}</li>
      <li><b>ot</b>{t} : autre longueur (mm){/t}</li>
      <li><b>weight</b>{t} : poids (g){/t}</li>
      <li><b>age</b>{t} : age (année){/t}</li>
      <li><b>individual_comment</b>{t} : commentaire libre{/t}</li>
      <li><b>pathology_codes</b>{t} : liste des codes de pathologie ou remarques{/t}</li>
      <li><b>sexe_id</b>{t} : sexe : 1: femelle, 2: mâle, 3: inconnu, 4: non identifié{/t}</li>
      <li><b>pathology_id</b>{t} : identifiant de la pathologie (voir la table correspondante dans les paramètres){/t}</li>
      <li><b>transmitter_type_id</b>{t} : identifiant du type de transmetteur (voir la table correspondante dans les paramètres){/t}</li>
      <li><b>release_station_id</b>{t} : identifiant de la station de lâcher (voir la table correspondante dans les paramètres){/t}</li>
    </ul>
  </div>
</div>