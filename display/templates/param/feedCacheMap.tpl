<link rel="stylesheet" href="display/bower_components/leaflet-draw/dist/leaflet.draw.css">
<script src="display/bower_components/leaflet-draw/dist/leaflet.draw.js"></script>
<script>
    $(document).ready(function () {
        var map = new L.Map("map", {
            drawControl: true
        });
        var osmUrl = '{literal}https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png{/literal}';
        var osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
        var cacheMaxAge = "{$mapCacheMaxAge}";
        var mapSeedMaxZoom = "{$mapSeedMaxZoom}";
        var mapSeedMinZoom = "{$mapSeedMinZoom}";
        var mapSeedMaxAge = "{$mapSeedMaxAge}";
        var mapMinZoom = "{$mapMinZoom}";
        var mapMaxZoom = "{$mapMaxZoom}";
        var osm = new L.TileLayer(osmUrl, {
            minZoom: mapMinZoom,
            maxZoom: mapMaxZoom,
            attribution: osmAttrib,
            useCache: true,
            crossOrigin: true,
            cacheMaxAge: cacheMaxAge
        });
        var zoom = 5;
        var mapDefaultZoom = "{$mapDefaultZoom}";
        if (!isNaN(mapDefaultZoom)) {
            zoom = mapDefaultZoom;
        }
        var mapDefaultLong = "{$mapDefaultLong}";
        var mapDefaultLat = "{$mapDefaultLat}";
        map.setView([mapDefaultLat, mapDefaultLong], zoom);
        map.addLayer(osm);
        var position;
        var drawnItems = new L.FeatureGroup();
        map.addLayer(drawnItems);
        /*var drawControl = L.Control.Draw({
            draw: {
                polygon: false,
                marker: false,
                circle: false,
                polyline: false,
                circlemarker: false
            },
            edit: {
                featureGroup: drawnItems
            }
        });*/
        var toolbar = L.Toolbar();
        toolbar.addToolbar(map);
        //map.addControl(drawControl);
        map.on('draw:created draw:edit', function (e) { 
            var layer = e.layer;
            layer.on("mouseover", function() { 
                position = layer.getLatLngs();
                console.log(position);
            });
        });
        $("#zoomLevel").text(zoom);
        map.zoomlevelschange(function () {
            $("#zoomLevel").text(map.getZoom());
        });
        $("#zoomMin").change(function () {
            var z = $(this).val();
            if (z < mapSeedMinZoom) {
                $(this).val(mapSeedMinZoom);
            }
        });
        $("#zoomMax").change(function () {
            var z = $(this).val();
            if (z > mapSeedMaxZoom) {
                $(this).val(mapSeedMaxZoom);
            }
        });
    });
</script>
<h2>{t}Mise en cache de la cartographie{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <div id="map" class="map"></div>
        <br>
        {t}Niveau de zoom actuel :{/t}&nbsp;<div id="zoomLevel"></div>
    </div>
    <div class="col-md-6  form-horizontal">
        <div class="form-group">
            <label for="zoomMin" class="control-label col-md-4">{t}Niveau de zoom minimum souhaité :{/t}</label>
            <div class="col-md-8">
                <input id="zoomMin" type="number" class="form-control nombre" value="{$mapSeedMinZoom}">
            </div>
        </div>
        <div class="form-group">
            <label for="zoomMax" class="control-label col-md-4">{t}Niveau de zoom maximum souhaité :{/t}</label>
            <div class="col-md-8">
                <input id="zoomMax" type="number" class="form-control nombre" value="{$mapSeedMaxZoom}">
            </div>
        </div>
        <div class="form-group">
            <label for="ageMax" class="control-label col-md-4">{t}Durée en jours de conservation du cache souhaitée
                :{/t}</label>
            <div class="col-md-8">
                <input id="ageMax" type="number" class="form-control nombre" value="{$mapSeedMaxAge}">
            </div>
        </div>
    </div>
</div>