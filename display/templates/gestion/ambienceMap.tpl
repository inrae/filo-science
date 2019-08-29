<script type="text/javascript" charset="utf-8" src="display/javascript/ol-v4.2.0-dist/ol.js"></script>
<link rel="stylesheet" type="text/css" href="display/javascript/ol-v4.2.0-dist/ol.css">
<div id="mapAmbience" class="map"></div>
{if $mapMode == "edit"}
  <div id="radar">
    <a href="#">
    <img src="display/images/map-pointer.png" height="30">{t}Repérez votre position !{/t}</a>
  </div>
{/if}
<div id="mapAmbience" class="map"></div>
<script>
var earth_radius = 6389125.541;
var zoom = {$mapDefaultZoom};
var mapCenter = [{$mapDefaultLong}, {$mapDefaultLat}];
{if strlen({$ambience.ambience_long})>0 && strlen({$ambience.ambience_lat})>0} 
	mapCenter = [{$ambience.ambience_long}, {$ambience.ambience_lat}];
{/if}
function getStyle() {
	var styleRed = new ol.style.Style( { 
		image: new ol.style.Circle({
		    radius: 6,
		    fill: new ol.style.Fill({
		          color: [255, 0, 0, 0.5]
		 	}),
			stroke: new ol.style.Stroke( { 
				color: [255 , 0 , 0 , 1],
				width: 1
			})
		})
	});
return styleRed;
}

var attribution = new ol.control.Attribution({
  collapsible: true
});
var mousePosition = new ol.control.MousePosition( { 
    coordinateFormat: ol.coordinate.createStringXY(2),
    projection: 'EPSG:4326',
    target: undefined,
    undefinedHTML: '&nbsp;'
});
var view = new ol.View({
    center: ol.proj.fromLonLat(mapCenter),
    zoom: zoom
});
var mapAmbience = new ol.Map({
  controls: ol.control.defaults({ attribution: false }).extend([attribution]),
  target: 'mapAmbience',
  view: view
});

var layer = new ol.layer.Tile({
  source: new ol.source.OSM()
});

function transform_geometry(element) {
  var current_projection = new ol.proj.Projection({ code: "EPSG:4326" });
  var new_projection = layer.getSource().getProjection();

  element.getGeometry().transform(current_projection, new_projection);
}

mapAmbience.addLayer(layer);
var coordinates = [,];
var point;
var point_feature;
var features = new Array();
/*
 * Traitement de chaque localisation
 */
/*console.log("Début de traitement de l'affichage du point");
console.log("x : " + {$ambience.wgs84_x});
console.log("y  : "+ {$ambience.wgs84_y});
*/

//coordinates = [{$ambience.ambience_long}, {$ambience.ambience_lat}];
 point = new ol.geom.Point(coordinates);
 point_feature = new ol.Feature ( {
	geometry: point
});
point_feature.setStyle(getStyle());
features.push ( point_feature) ;

/*  
 * Fin d'integration des points
 * Affichage de la couche
 */
var layerPoint = new ol.layer.Vector({
  source: new ol.source.Vector( {
    features: features
  })
});
features.forEach(transform_geometry);
mapAmbience.addLayer(layerPoint);
mapAmbience.addControl(mousePosition);

function setPosition(lon, lat) {
    if (lon.length > 0 && lat.length > 0) {
        var lonlat3857 = ol.proj.transform([parseFloat(lon),parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');
        point.setCoordinates (lonlat3857);
        view.setCenter(lonlat3857);
    }
}
if (mapIsChange == true) {
    mapAmbience.on('click', function(evt) {
        var lonlat3857 = evt.coordinate;
        var lonlat = ol.proj.transform(lonlat3857, 'EPSG:3857', 'EPSG:4326');
        var lon = lonlat[0];
        var lat = lonlat[1];
        //console.log("longitude sélectionnée : "+ lon);
        //console.log ("latitude sélectionnée : " + lat);
        point.setCoordinates (lonlat3857);
        $("#ambience_long").val(lon);
        $("#ambience_lat").val(lat);
    });
}

/*
 * Traitement de la localisation par clic sur le radar 
 * (position approximative du terminal)
 */
 $("#radar").click(function () { 
	 if (navigator && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition( function (position) {
        var lon = position.coords.longitude;
        var lat = position.coords.latitude;
    //console.log("longitude calculée : "+ lon);
    //console.log ("latitude calculée : " + lat);
        $("#ambience_long").val(lon);
        $("#ambience_lat").val(lat);
        var lonlat3857 = ol.proj.transform([parseFloat(lon),parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');
        point.setCoordinates (lonlat3857);
        view.setCenter(lonlat3857);
      });   
   }
 });
</script>