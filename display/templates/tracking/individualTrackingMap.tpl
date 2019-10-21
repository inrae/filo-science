<div id="map" class="map"></div>

<script>
    var map = new L.Map("map");
    var osmUrl = '{literal}https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png{/literal}';
    var osmAttrib = 'Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
    var cacheMaxAge = "{$mapCacheMaxAge}";
    var mapDefaultZoom = "{$mapDefaultZoom}";
    var mapDefaultLong = "{$mapDefaultLong}";
    var mapDefaultLat = "{$mapDefaultLat}";
    var mapData = {};
    var mapFields = {
        'cacheMaxAge': 'cacheMaxAge',
        'mapDefaultZoom': 'mapDefaultZoom',
        'mapDefaultLong': 'mapDefaultLong',
        'mapDefaultLat': 'mapDefaultLat'
    };
    for (var key in mapFields) {
        try {
            var value = Cookies.get(mapFields[key]);
            if (!isNaN(value)) {
                mapData[key] = value;
            }
        } catch { }
    }

    var zoom = 5;
    if (!isNaN(mapData.mapDefaultZoom)) {
        zoom = mapData.mapDefaultZoom;
    }

    var osm = new L.TileLayer(osmUrl, {
        minZoom: 5,
        maxZoom: 20,
        attribution: osmAttrib,
        useCache: true,
        crossOrigin: true,
        cacheMaxAge: cacheMaxAge
    });

    var markers = new L.FeatureGroup();
    var polylines = new L.FeatureGroup();
    var latlngs = [];
    var long = 0, longBefore = 0, lat = 0, latBefore = 0;

    {foreach $detections as $detection}
        lat = parseFloat("{$detection.lat}");
        long = parseFloat("{$detection.long}");
        if (lat != latBefore && long != longBefore ) {
            var latlong = [lat,long];
            latlngs.push (latlong);
            var id = "{$detection.id}";
            var marker = L.marker(latlong, { title: "{if $detection.detection_type == 'stationary'}{$detection.station_name} {$detection.id}{else}{t}mobile : {/t}{$detection.id}{/if}"});
            marker.addTo(markers);
            latBefore = lat;
            longBefore = long;
        }
    {/foreach}
    
    map.addLayer(osm);
    if (latlngs.length > 1) {
        var polyline = L.polyline(latlngs, { color: "red", snackingSpeed: 200});
       // map.setView(polyline.getCenter());
        map.fitBounds(polyline.getBounds());
        polyline.addTo(polylines);
        polylines.addTo(map).snakeIn();
    } else {
        map.setView([mapData.mapDefaultLat, mapData.mapDefaultLong], zoom);
    }
    markers.addTo(map);
    
</script>