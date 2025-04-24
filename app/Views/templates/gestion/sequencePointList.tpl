<div class="row">
        <fieldset class="col-md-12">
            <a href="sequencePointChange?sequence_id={$data.sequence_id}&sequence_point_id=0">
                <img src="display/images/new.png" height="25">{t}Nouveau point de prélèvement{/t}
            </a>
            <div class="col-md-12">
                <table class="table table-bordered table-hover datatable display" data-order='[[0,"asc"]]'>
                    <thead>
                        <tr>
                            <th>{t}N° d'ordre{/t}</th>
                            <th>{t}Localisation{/t}</th>
                            <th>{t}Faciès{/t}</th>
                            <th>{t}Nbre de poissons{/t}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach $points as $point}
                        <tr>
                            <td class="center">
                                <a href="sequencePointChange?sequence_id={$point.sequence_id}&sequence_point_id={$point.sequence_point_id}">
                                    {$point.sequence_point_number}
                                </a>
                            </td>
                            <td>{$point.localisation_name}</td>
                            <td >{$point.facies_name}</td>
                            <td class="center">{$point.fish_number}</td>
                        </tr>
                        {/foreach}
                    </tbody>
                </table>
            </div>
        </fieldset>
    </div>