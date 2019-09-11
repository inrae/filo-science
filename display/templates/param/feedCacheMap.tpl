<link rel="stylesheet" href="display/bower_components/leaflet-draw/dist/leaflet.draw.css">
<script src="display/bower_components/leaflet-draw/dist/leaflet.draw.js"></script>

<script>
    $(document).ready(function () {
        var map = new L.Map("map", {
            drawControl: false
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
        osm.addTo(map);
        //map.addLayer(osm);
        var position;
        var editableLayers = new L.FeatureGroup();
        map.addLayer(editableLayers);
        var options = {
            draw: {
                polyline: false,
                polygon: false,
                circle: false,
                marker: false,
                circlemarker: false
            },
            edit: {
                featureGroup: editableLayers,
                remove: false
            }
        };
        var drawControl = new L.Control.Draw(options);
        L.control.scale().addTo(map);
        map.addControl(drawControl);
        map.on(L.Draw.Event.CREATED, function (e) {
            var type = e.layerType,
                layer = e.layer;
            editableLayers.addLayer(layer);
            position = layer.getLatLngs();
        });
        map.on(L.Draw.Event.EDITED, function (e) {
            var layers = e.layers;
            layers.eachLayer(function (layer) {
                position = layer.getLatLngs();
            });
        });

        $("#zoomLevel").text(zoom);
        map.on("zoomend", function () {
            $("#zoomLevel").text(map.getZoom());
        });
        $("#zoomMin").change(function () {
            var z = $(this).val();
            if (z < parseInt(mapSeedMinZoom)) {
                $(this).val(mapSeedMinZoom);
            }
        });
        $("#zoomMax").change(function () {
            var z = $(this).val();
            if (z > parseInt(mapSeedMaxZoom)) {
                $(this).val(mapSeedMaxZoom);
            }
        });

        $("#feedExec").on("click keyup", function () {
            if (position != undefined) {
                console.log(position);
                try {
                    var zmin = parseInt($("#zoomMin").val());
                    var zmax = parseInt($("#zoomMax").val());
                    var bbox = L.latLngBounds(position[0], L.latLngBounds(position[2]));
                    console.log(bbox);
                    console.log(zmin);
                    console.log(zmax);
                    if (zmin > 0 && zmax > 0 && zmax >= zmin) {
                        // set the maxCacheAge value
                        cacheMaxAge = parseInt($("#ageMax").val()) * 3600 * 1000;
                        if (cacheMaxAge > 0) {
                            osm.cacheMaxAge = cacheMaxAge;
                        }
                        $("#seedMessage").text("{t}Patientez pendant le téléchargement...{/t}");
                        osm.seed(bbox, zmin, zmax);
                    }
                } catch (e) {
                    console.log(e.message);
                }
            }
        });
        osm.on("seedstart", function (e) {
            $("#seedMessage").text(e.queueLength + " {t}dalles à télécharger{/t}");
        });
        osm.on("seedprogress", function (e) {
            $("#seedMessage").text(e.remainingLength + " {t}dalles restantes{/t}");
        });
        osm.on("seedend", function (e) {
            $("#seedMessage").text("{t}Téléchargement terminé !{/t}");
        });
        osm.on("tilecacheerror", function (e) {
            $("#seedMessage").html("{t}Une erreur est survenue pendant le téléchargement{/t}<br>" + e.error);
        });
    });
</script>
<h2>{t}Mise en cache de la cartographie{/t}</h2>
<div class="row">
    <div class="col-md-6">
        <div id="map" class="map"></div>
        <br>
        {t}Niveau de zoom actuel :{/t}&nbsp;<span id="zoomLevel"></span>
    </div>
    <div class="col-md-6  form-horizontal">
        <div class="center col-md-12" id="seedMessage"></div>
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
            <label for="ageMax" class="control-label col-md-4">{t}Durée de conservation du cache souhaitée (en jours)
                :{/t}</label>
            <div class="col-md-8">
                <input id="ageMax" type="number" class="form-control nombre" value="{$mapSeedMaxAge}">
            </div>
        </div>
        <div class="form-group">
            <div class="col-md-12 center">
                <button class="btn btn-danger" id="feedExec">{t}Télécharger la cartographie sélectionnée{/t}</button>
            </div>
        </div>
    </div>
</div>