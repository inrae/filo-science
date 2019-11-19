<script type="text/javascript" charset="utf-8" src="display/javascript/ol-v4.2.0-dist/ol.js"></script>
<link rel="stylesheet" type="text/css" href="display/javascript/ol-v4.2.0-dist/ol.css">
<script src="display/javascript/proj4.js"></script>
<script>
    var map = setMap("mapOperation");


    var long_start = "{$data.long_start}";
    var lat_start = "{$data.lat_start}";
    var long_end = "{$data.long_end}";
    var lat_end = "{$data.lat_end}";

    var pointNumber = 1;
    var point1, point2;
    function setPosition(numpoint, lat, long) {
        if (numpoint == 1) {
            if (point1 == undefined) {
                point1 = L.marker([lat, long]);
                point1.addTo(map).bindPopup("1");
                point2 = L.marker([lat, long]);
                point2.addTo(map).bindPopup("2");
                $("#long_end").val(long);
                $("#lat_end").val(lat);
            } else {
                point1.setLatLng([lat, long]);
            }
            map.setView([lat, long]);
        } else {
            point2.setLatLng([lat, long]);
        }
    }
    if (long_start.length > 0 && lat_start.length > 0) {
        mapData.mapDefaultLong = long_start;
        mapData.mapDefaultLat = lat_start;
        point1 = L.marker([lat_start, long_start]);
    }
    if (long_end != undefined && lat_end != undefined) {
        point2 = L.marker([lat_end, long_end]);
    }
    mapDisplay(map);
    if (point1 != undefined) {
        point1.addTo(map).bindPopup("1");
    }
    if (point2 != undefined) {
        point2.addTo(map).bindPopup("2");
    }

    if (mapIsChange == true) {
        map.on('click', function (e) {
            if (pointNumber == 1) {
                setPosition(1, e.latlng.lat, e.latlng.lng);
                $("#long_start").val(e.latlng.lng);
                $("#lat_start").val(e.latlng.lat);
                pointNumber = 2;
            } else {
                setPosition(2, e.latlng.lat, e.latlng.lng);
                $("#long_end").val(e.latlng.lng);
                $("#lat_end").val(e.latlng.lat);
                pointNumber = 1;
            }
        });
    }


    $("#radar").click(function () {
        if (navigator && navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                var lon = position.coords.longitude;
                var lat = position.coords.latitude;
                if (pointNumber == 1) {
                    setPosition(1, lat, lon);
                    $("#long_start").val(lon);
                    $("#lat_start").val(lat);
                    pointNumber = 2;
                } else {
                    setPosition(2, lat, lon);
                    $("#long_end").val(lon);
                    $("#lat_end").val(lat);
                    pointNumber = 1;
                }
            });
        }
    });

</script>
