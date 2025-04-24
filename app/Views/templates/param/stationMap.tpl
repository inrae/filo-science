<div id="map" class="map"></div>
{include file="mapDefault.tpl"}
<script>
  var map = setMap("map");

  var long = "{$data.station_long}";
  var lat = "{$data.station_lat}";
  var point;

  function setPosition(lat, long) {
    if (point == undefined) {
      point = L.marker([lat, long]);
      point.addTo(map).bindPopup("1");
    } else {
      point.setLatLng([lat, long]);
    }
    map.setView([lat, long]);
  }
  $(".position").change(function () {
    var lon = $("#station_long").val();
    var lat = $("#station_lat").val();
    if (lon.length > 0 && lat.length > 0) {
      setPosition(lat, lon);
    }
  });

  if (long.length > 0 && lat.length > 0) {
    mapData.mapDefaultLong = long;
    mapData.mapDefaultLat = lat;
    point = L.marker([lat, long]);
  }
  mapDisplay(map);
  if (point != undefined) {
    point.addTo(map).bindPopup("1");
  }

  if (mapIsChange == true) {
    map.on('click', function (e) {
      setPosition(e.latlng.lat, e.latlng.lng);
      $("#station_long").val(e.latlng.lng);
      $("#station_lat").val(e.latlng.lat);
    });
    $("#radar").click(function () {
      if (navigator && navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {
          var lon = position.coords.longitude;
          var lat = position.coords.latitude;
          setPosition(lat, lon);
          $("#station_long").val(lon);
          $("#station_lat").val(lat);
        });
      }
    });
  }


</script>