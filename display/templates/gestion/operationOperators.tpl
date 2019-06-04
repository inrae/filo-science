<div class="col-md-12">
    <fieldset>
        <legend>{t}Opérateurs{/t}</legend>
        <form id="operators">
            <input type="hidden" name="activeTab" value="tab-operator">
            <input type="hidden" name="operation_id" value="{$data.operation_id}">
            <input type="hidden" name="campaign_id" value="{$data.campaign_id}">
            <table id="operators" class="table table-bordered table-hover datatable " data-order='[[0,"asc"]]' >
                <thead>
                    <tr>
                        <th>{t}Nom - prénom{/t}</th>
                        <th>{t}Participe à l'opération{/t}</th>
                        <th>{t}Est le responsable{/t}</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach $operators as $operator}
                        <tr>
                            <td>{$operator.name}&nbsp;{$operator.firstname}</td>
                            <td class="center">
                                <input type="checkbox" name="operators[]" value="{$operator.operator_id}" {if $operator.operation_id > 0}checked{/if}>
                            </td>
                            <td class="center">
                                <input type="radio" name="operator_responsible" value="{$operator.operator_id}" {if $operator.is_responsible == 1}checked{/if}>
                            </td>
                        </tr>
                    {/foreach}
                </tbody>
            </table>
        </form>
    </fieldset>
</div>