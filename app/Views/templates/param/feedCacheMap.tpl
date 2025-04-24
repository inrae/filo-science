<link rel="stylesheet" href="display/node_modules/leaflet-draw/dist/leaflet.draw.css">
<script src="display/node_modules/leaflet-draw/dist/leaflet.draw.js"></script>

<script>
    $(document).ready(function () {
        var map = new L.Map("map", {
            drawControl: false
        });
        var variablesNames = ['cacheMaxAge', 'mapSeedMaxZoom', 'mapSeedMinZoom', 'mapSeedMaxAge', 'mapMinZoom', 'mapMaxZoom', 'mapDefaultLong', 'mapDefaultLat', 'mapDefaultZoom'];
        var mapData = {};
        mapData.cacheMaxAge = "{$mapCacheMaxAge}";
        mapData.mapSeedMaxZoom = "{$mapSeedMaxZoom}";
        mapData.mapSeedMinZoom = "{$mapSeedMinZoom}";
        mapData.mapSeedMaxAge = "{$mapSeedMaxAge}";
        mapData.mapMinZoom = "{$mapMinZoom}";
        mapData.mapMaxZoom = "{$mapMaxZoom}";
        mapData.mapDefaultLong = "{$mapDefaultLong}";
        mapData.mapDefaultLat = "{$mapDefaultLat}";
        mapData.mapDefaultZoom = "{$mapDefaultZoom}";
        variablesNames.forEach(function (item, index, array) {
            /**
             * Surround the values with the cookie
             */
            try {
                var value = Cookies.get(item);
                if (value.length > 0) {
                    mapData[item] = parsefloat(value);
                }
            } catch { }

        });
        var osmUrl = '{literal}https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png{/literal}';
        var osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
        var center = [mapData.mapDefaultLat, mapData.mapDefaultLong];


        var osm = new L.TileLayer(osmUrl, {
            minZoom: mapData.mapMinZoom,
            maxZoom: mapData.mapMaxZoom,
            attribution: osmAttrib,
            useCache: true,
            crossOrigin: true,
            cacheMaxAge: mapData.cacheMaxAge
        });
        var zoom = 5;
        if (!isNaN(mapData.mapDefaultZoom)) {
            zoom = mapData.mapDefaultZoom;
        }

        map.setView(center, zoom);
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
            center = layer.getCenter();
        });
        map.on(L.Draw.Event.EDITED, function (e) {
            var layers = e.layers;
            layers.eachLayer(function (layer) {
                position = layer.getLatLngs();
                center = layer.getCenter();

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
                try {
                    var zmin = parseInt($("#zoomMin").val());
                    var zmax = parseInt($("#zoomMax").val());
                    var bbox = L.latLngBounds(position[0], L.latLngBounds(position[2]));
                    if (zmin > 0 && zmax > 0 && zmax >= zmin) {
                        // set the maxCacheAge value
                        mapData.cacheMaxAge = parseInt($("#ageMax").val()) * 24 * 3600 * 1000;
                        mapData.mapDefaultLong = center.lng;
                        mapData.mapDefaultLat = center.lat;
                        mapData.mapDefaultZoom = map.getZoom();
                        /**
                         * set cookies
                         */
                        variablesNames.forEach(function (item, index, array) {
                            Cookies.set(item, mapData[item], { expires: 180, sameSite: "strict", secure: true });
                        });
                        $("#seedMessage").text("{t}Patientez pendant le téléchargement...{/t}");
                        osm.seed(bbox, zmin, zmax);
                    }
                } catch (e) {
                    console.log(e.message);
                }
            }
        });

        $("#ageMax").change(function () {
            Cookies.set('cacheMaxAge', parseInt($(this).val()) * 24 * 3600 * 1000, {sameSite: "strict", secure: true});
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
        <div class="row">
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
                <label for="ageMax" class="control-label col-md-4">{t}Durée de conservation du cache (en jours)
                    :{/t}</label>
                <div class="col-md-8">
                    <input id="ageMax" type="number" class="form-control nombre" value="{$mapSeedMaxAge}">
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-12 center">
                    <button class="btn btn-danger" id="feedExec">{t}Télécharger la cartographie
                        sélectionnée{/t}</button>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="bg-info">
                {t}Ce module permet de télécharger les dalles cartographiques pour un usage hors ligne. Vous devez indiquer :{/t}
                <br>
                <ul>
                    <li>{t}le niveau de zoom minimum{/t}</li>
                    <li>{t}Le niveau de zoom maximum{/t}</li>
                    <li>{t}La durée de conservation du cache (en jours) : pendant cette période, votre navigateur n'essaiera pas de télécharger de nouvelles versions des dalles téléchargées{/t}</li>
                </ul>
                <b>{t}Attention :{/t}</b> {t}plus la zone à télécharger est grande, plus les niveaux de zoom sont nombreux, et plus important sera le temps de téléchargement.{/t}
                <br>{t}Limitez-vous aux dalles qui vous sont nécessaires : vous risqueriez de vous faire interdire de téléchargement par les serveurs OpenStreetMap en cas d'abus.{/t}
                <br>
                {t}Pour télécharger des dalles :{/t}
                <ul>
                    <li>{t}vérifiez les niveaux de zoom dont vous avez besoin{/t}</li>
                    <li>{t}sur la carte, sélectionnez en cliquant sur le carré (draw a rectangle) la zone concernée{/t}</li>
                    <li>{t}une fois tous les paramètres corrects, cliquez sur le bouton Télécharger la cartographie sélectionnée{/t}</li>
                </ul>
                {t}Pour interrompre l'opération, allez sur une autre page de l'application.{/t}
                <br>
                {t}La durée de conservation du cache indiquée ici est valable pour toutes les cartes.{/t}
            </div>
        </div>
    </div>
</div>
