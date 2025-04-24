<h2>{t}Liste des operateurs{/t}</h2>
<div class="row">
    <div class="col-md-6">
        {if $rights.param == 1}
            <img src="display/images/new.png" height="25">
            <a href="operatorChange?operator_id=0">
                {t}Nouveau...{/t}
            </a>
        {/if}
        <table id="paramList" class="table table-bordered table-hover datatable " data-order='[[1,"asc"],[2,"asc"]]' >
            <thead>
                <tr>
                    <th>{t}Id{/t}</th>
                    <th>{t}Nom{/t}</th>
                    <th>{t}Prénom{/t}</th>
                    <th>{t}Actif ?{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach $data as $row}
                    <tr>
                        <td class="center">{$row["operator_id"]}</td>
                        <td>
                            {if $rights.param == 1}
                            <a href='operatorChange?operator_id={$row["operator_id"]}'>
                            {$row["name"]}
                            </a>
                            {else}
                            {$row["name"]}
                            {/if}
                        </td>
                        <td>{$row["firstname"]}</td>
                        <td class="center">
                            {if $row["is_active"] == 1}{t}oui{/t}{else}{t}non{/t}{/if}
                        </td>
                    </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>