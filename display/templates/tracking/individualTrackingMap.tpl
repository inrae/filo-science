<div id="map" class="map"></div>
{include file="mapDefault.tpl"}
<script>
  var map = setMap("map");
  var markers = new L.FeatureGroup();
  var polylines = new L.FeatureGroup();
  var latlngs = [];
  var long = 0, longBefore = 0, lat = 0, latBefore = 0;
	/**
	 * set the trace and the markers - Smarty code
	 */
  {foreach $detections as $detection }
  lat = parseFloat("{$detection.lat}");
  long = parseFloat("{$detection.long}");
  if (lat != latBefore && long != longBefore) {
    var latlong = [lat, long];
    latlngs.push(latlong);
    var titre= "{if $detection.detection_type == 'stationary'}{$detection.station_name} {$detection.id}{else}{t}mobile : {/t}{$detection.id}{/if}";
    var id = "{$detection.id}";
    var marker = L.marker(latlong)
      .bindTooltip(titre,
      {
          permanent: false,
          direction: 'right'
      })
    ;
    marker.addTo(markers);
    latBefore = lat;
    longBefore = long;
  }
  {/foreach}
    if (latlngs.length == 1) {
      //map.setView(latlngs[0], zoom);
      mapData["mapDefaultLong"] = latlngs[0][1];
      mapData["mapDefaultLat"] = latlngs[0][0];
    }
    function display() {
      mapDisplay(map);
      if (latlngs.length > 1) {
        var polyline = L.polyline(latlngs, { color: "red", snackingSpeed: 200 });
        // map.setView(polyline.getCenter());
        map.fitBounds(polyline.getBounds());
        polyline.addTo(polylines);
        polylines.addTo(map).snakeIn();
      }
      markers.addTo(map);
    }

</script>