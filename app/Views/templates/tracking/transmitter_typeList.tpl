<h2>{t}Liste des types d'émetteurs{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {if $rights.param == 1}
        <a href="transmitter_typeChange&transmitter_type_id=0">
            <img src="display/images/new.png" height="25">
            {t}Nouveau...{/t}
        </a>
        {/if}
        <table id="paramList" class="table table-bordered table-hover datatable-searching ">
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Type{/t}</th>
                    <th>{t}Caractéristiques{/t}</th>
                    <th>{t}Technologie{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $data as $row}
                <tr>
                    <td class="center">{$row["transmitter_type_id"]}</td>
                    <td>
                        {if $rights.param == 1}
                        <a
                            href='transmitter_typeChange&transmitter_type_id={$row["transmitter_type_id"]}'>
                            {$row["transmitter_type_name"]}
                            {else}
                            {$row["transmitter_type_name"]}
                            {/if}
                    </td>
                    <td class="textareaDisplay">{$row["characteristics"]}</td>
                    <td class="center">
                        {$row["technology"]}
                    </td>
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>