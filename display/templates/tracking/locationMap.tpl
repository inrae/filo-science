<div id="map" class="map"></div>
<script>
	var map = new L.Map("map");
  var osmUrl='{literal}https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png{/literal}';
  var osmAttrib='Map data © <a href="https://openstreetmap.org">OpenStreetMap</a> contributors';
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

  var long = "{$data.location_long}";
  var lat = "{$data.location_lat}";
  var point;


function setPosition(lat, long) {
    if (point == undefined) {
      point = L.marker([lat,long]);
      point.addTo(map).bindPopup("1"); 
    } else {
        point.setLatLng([lat, long]);
    }
    map.setView([lat, long]);
  }
	$(".position").change(function () {
		var lon = $("#location_long").val();
		var lat = $("#location_lat").val();
		if (lon.length > 0 && lat.length > 0) {
			setPosition(lat, lon);
		}
	});

if (long.length >0 && lat.length > 0) {
      mapData.mapDefaultLong = long;
      mapData.mapDefaultLat = lat;
      point = L.marker([lat, long]);
  }
  map.setView ([mapData.mapDefaultLat, mapData.mapDefaultLong], zoom);
  map.addLayer(osm);
  if ( point != undefined) {
      point.addTo(map).bindPopup("1");
  }

if ( mapIsChange == true) {
  map.on('click', function(e) {    
    setPosition( e.latlng.lat, e.latlng.lng);
    $("#location_long").val(e.latlng.lng);
    $("#location_lat").val(e.latlng.lat);
  });
  $("#radar").click(function () { 
	 if (navigator && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition( function (position) {
        var lon = position.coords.longitude;
        var lat = position.coords.latitude;
        setPosition( lat,lon);
        $("#location_long").val(lon);
        $("#location_lat").val(lat);
      });
   }
  });
}


</script>