
<div class="row">
    <fieldset class="col-md-12">
        <a href="sampleChange?sequence_id={$data.sequence_id}&sample_id=0">
            <img src="display/images/new.png" height="25">{t}Nouveau lot{/t}
        </a>
        <div class="col-md-12">
            <table class="table table-bordered table-hover datatable-nopaging display" data-order='[[0,"desc"]]'>
                <thead>
                    <tr>
                        <th>{t}Id{/t}</th>
                        <th>{t}Taxon{/t}</th>
                        <th>{t}Nombre total{/t}</th>
                        <th>{t}Nombre mesurés{/t}</th>
                        <th>{t}Poids total (g){/t}</th>
                        <th>{t}Taille mini mesurée (mm){/t}</th>
                        <th>{t}Taille maxi mesurée (mm){/t}</th>
                        <th>{t}Mesures complémentaires{/t}</th>
                        <th>{t}Commentaires{/t}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $samples as $sample}
                    <tr>
                        <td class="center">{$sample.sample_uid}</td>
                        <td class="center">
                            <a href="sampleChange?sequence_id={$sample.sequence_id}&sample_id={$sample.sample_id}">
                                {$sample.taxon_name}
                            </a>
                        </td>
                        <td class="center">{$sample.total_number}</td>
                        <td class="center">{$sample.total_measured}</td>
                        <td class="center">{$sample.total_weight}</td>
                        <td class="center">{$sample.sample_size_min}</td>
                        <td class="center">{$sample.sample_size_max}</td>
                        <td>{$sample.other_measures}</td>
                        <td class="textareaDisplay">{$sample.sample_comment}</td>
                    </tr>
                    {/foreach}
                </tbody>
            </table>
        </div>
    </fieldset>
</div>
