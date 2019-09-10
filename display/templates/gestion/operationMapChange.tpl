
<script>
    var map = new L.Map("mapOperation");
    var osmUrl='{literal}https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png{/literal}';
    var osmAttrib='Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
    var cacheMaxAge = "{$mapCacheMaxAge}";
    var osm = new L.TileLayer(osmUrl, { 
        minZoom: 5, 
        maxZoom: 20, 
        attribution: osmAttrib,
        useCache: true,
        crossOrigin: true,
        cacheMaxAge: cacheMaxAge
        });
    var zoom = 5;
    var mapDefaultZoom = "{$mapDefaultZoom}";
    if (! isNaN(mapDefaultZoom)) {
        zoom = mapDefaultZoom;
    }
    var mapDefaultLong = "{$mapDefaultLong}";
    var mapDefaultLat = "{$mapDefaultLat}";
    var long_start = "{$data.long_start}";
    var lat_start = "{$data.lat_start}";
    var long_end =  "{$data.long_end}";
    var lat_end = "{$data.lat_end}";
    
    var pointNumber = 1;
    var point1, point2;
    function setPosition(numpoint, lat, long) {
        if (numpoint == 1) {
           if (point1 == undefined) {
                point1 = L.marker([lat,long]);
                point1.addTo(map).bindPopup("1");
                point2 = L.marker([lat,long]);
                point2.addTo(map).bindPopup("2");
                $("#long_end").val(long);
                $("#lat_end").val(lat);
           } else {
               point1.setLatLng([lat, long]);
           }
           map.setView([lat, long]);
        }  else {
           point2.setLatLng([lat, long]);   
        }
    }
    if (long_start.length >0 && lat_start.length > 0) {
        mapDefaultLong = long_start;
        mapDefaultLat = lat_start;
        point1 = L.marker([lat_start, long_start]);
    }
    if (long_end != undefined && lat_end != undefined) {
        point2 = L.marker([lat_end, long_end]);
    }
    map.setView ([mapDefaultLat, mapDefaultLong], zoom);
    map.addLayer(osm);
    if ( point1 != undefined) {
        point1.addTo(map).bindPopup("1");
    }
    if ( point2 != undefined) {
        point2.addTo(map).bindPopup("2");
    }
    
    if ( mapIsChange == true) {
        map.on('click', function(e) { 
            if (pointNumber == 1) {
                setPosition(1, e.latlng.lat, e.latlng.lng);
                $("#long_start").val(e.latlng.lng);
                $("#lat_start").val(e.latlng.lat);
                pointNumber = 2;
            } else {
                setPosition(2,e.latlng.lat, e.latlng.lng);
                $("#long_end").val(e.latlng.lng);
                $("#lat_end").val(e.latlng.lat);
                pointNumber = 1;
            }
        });
    }


    $("#radar").click(function () { 
	 if (navigator && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition( function (position) {
        var lon = position.coords.longitude;
        var lat = position.coords.latitude;
    //console.log("longitude calculée : "+ lon);
    //console.log ("latitude calculée : " + lat);
            if (pointNumber == 1) {
                setPosition(1, lat,lon);
                $("#long_start").val(lon);
                $("#lat_start").val(lat);
                pointNumber = 2;
            } else {
                setPosition(2, lat,lon);
                $("#long_end").val(lon);
                $("#lat_end").val(lat);
                pointNumber = 1;
            }
      });   
   }
 });    
   
</script>