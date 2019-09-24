<script>
    var mapIsChange = false;
    $(document).ready(function () {
        
        /**
        * Tab management
        */
        var tabHover = 0;
        try {
            tabHover = Cookies.get("tabHover");
        } catch (Exception) { }
        if (tabHover == 1) {
            $("#tabHoverSelect").prop("checked", true);
        }
        $("#tabHoverSelect").change(function () {
            if ($(this).is(":checked")) {
                tabHover = 1;
            } else {
                tabHover = 0;
            }
            Cookies.set("tabHover", tabHover, { expires: 365 });
        });
        var activeTab = "{$activeTab}";
        if (activeTab.length == 0) {
            try {
                activeTab = Cookies.get("stationTrackingDisplayTab");
            } catch (Exception) {
                activeTab = "";
            }
        }
        try {
            if (activeTab.length > 0) {
                $("#" + activeTab).tab('show');
            }
        } catch (Exception) { }
        $('.nav-tabs > li > a').hover(function () {
            if (tabHover == 1) {
                $(this).tab('show');
            }
        });
        $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
            Cookies.set("stationTrackingDisplayTab", $(this).attr("id"));
        });
        $('a[data-toggle="tab"]').on("click", function () {
            tabHover = 0;
        });
    });

</script>

<h2>{t}station{/t}&nbsp;{$data.station_name}</h2>
<div class="row">
    <div class="col-md-12">
        <a href="index.php?module=stationTrackingList">
                <img src="display/images/list.png" height="25"> 
            {t}Retour à la liste{/t}
        </a>
        {if $droits.gestion == 1}
            &nbsp;
            <a href="index.php?module=stationTrackingChange&station_id={$data.station_id}">
                <img src="display/images/edit.gif" height="25">
                {t}Modifier...{/t}
            </a>
        {/if}
    </div>

    <ul class="nav nav-tabs" id="myTab" role="tablist">
        <li class="nav-item active">
            <a class="nav-link" id="tab-detail" data-toggle="tab" role="tab" aria-controls="nav-detail"
                aria-selected="true" href="#nav-detail">{t}Détails{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-antenna" href="#nav-antenna" data-toggle="tab" role="tab"
                aria-controls="nav-antenna" aria-selected="false">{t}Antennes{/t}</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" id="tab-probe" href="#nav-probe" data-toggle="tab" role="tab"
                aria-controls="nav-probe" aria-selected="false">{t}Sondes{/t}</a>
        </li>


    </ul>
    <div class="tab-content" id="nav-tabContent">
        <div class="tab-pane active in" id="nav-detail" role="tabpanel" aria-labelledby="tab-detail">
            <div class="col-md-12">
                {include file="tracking/stationTrackingDetail.tpl"}
            </div>
        </div>
        <div class="tab-pane fade" id="nav-antenna" role="tabpanel" aria-labelledby="tab-antenna">
            <div class="col-md-12">
                <h3>Antennes de réception</h3>
            </div>
        </div>
        <div class="tab-pane fade" id="nav-probe" role="tabpanel" aria-labelledby="tab-probe">
            <div class="col-md-12">
                <h3>Sondes d'analyse</h3>
            </div>
        </div>
    </div>
</div>


<div class="row">
    <div class="col-sm-12 messageBas">
        {t}Activer le survol des onglets :{/t}
        <input type="checkbox" id="tabHoverSelect">
    </div>
</div>