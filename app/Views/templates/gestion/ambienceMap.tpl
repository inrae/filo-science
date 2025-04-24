{if $mapMode == "edit"}
<div id="radar">
  <a href="#">
    <img src="display/images/map-pointer.png" height="30">{t}Repérez votre position !{/t}</a>
</div>
{/if}
<div id="mapAmbience" class="map"></div>
{include file="mapDefault.tpl"}
<script>
  var mapA = setMap("mapAmbience");

  var longA = "{$ambience.ambience_long}";
  var latA = "{$ambience.ambience_lat}";
  var pointA;
  function setPositionA(lat, long) {
    if (pointA == undefined) {
      pointA = L.marker([lat, long]);
      pointA.addTo(mapA).bindPopup("1");
    } else {
      pointA.setLatLng([lat, long]);
    }
    mapA.setView([lat, long]);
  }

  if (longA.length > 0 && latA.length > 0) {
    mapData.mapDefaultLongA = longA;
    mapData.mapDefaultLatA = latA;
    pointA = L.marker([latA, longA]);
  }
  mapDisplay(mapA);
  if (pointA != undefined) {
    pointA.addTo(mapA).bindPopup("1");
  }

  if (mapIsChange == true) {
    mapA.on('click', function (e) {
      setPositionA(e.latlng.lat, e.latlng.lng);
      $("#ambience_long").val(e.latlng.lng);
      $("#ambience_lat").val(e.latlng.lat);
    });
    $(".position").change(function () {
      var lon = $("#ambience_long").val();
      var lat = $("#ambience_lat").val();
      if (lon.length > 0 && lat.length > 0) {
        setPositionA(lat, lon);
      }
    });
    $("#radar").click(function () {
      if (navigator && navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {
          var lon = position.coords.longitude;
          var lat = position.coords.latitude;
          setPositionA(lat, lon);
          $("#ambience_long").val(lon);
          $("#ambience_lat").val(lat);
        });
      }
    });
  }
</script>