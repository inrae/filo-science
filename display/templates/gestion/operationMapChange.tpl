<script type="text/javascript" charset="utf-8" src="display/javascript/ol-v4.2.0-dist/ol.js"></script>
<link rel="stylesheet" type="text/css" href="display/javascript/ol-v4.2.0-dist/ol.css">
<script src="display/javascript/proj4.js"></script>
<script>
    var earth_radius = 6389125.541;
    var zoom = 5;
    {if $mapDefaultZoom > 0}zoom = {$mapDefaultZoom};{/if}
    var mapCenter = [{$mapDefaultLong}, {$mapDefaultLat}];
    var numpoint = 1;
    {if strlen({$data.long_start})>0 && strlen({$data.lat_start})>0} 
        mapCenter = [{$data.long_start}, {$data.lat_start}];
    {/if}
    function getStyle(libelle) {
        libelle = libelle.toString();
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
            }),
            text: new ol.style.Text( {
                textAlign: 'Left',
                text: libelle,
                textBaseline: 'middle',
                offsetX: 7,
                offsetY: 0,
                font: 'bold 12px Arial',
                /*fill: new ol.style.Fill({ color: 'rgba(255, 0, 0, 0.1)' }),
                stroke : new ol.style.Stroke({ color : 'rgba(255, 0, 0, 1)' })*/
            })
        });
    return styleRed;
    }
    var styleMarine = new ol.style.Style( { 
        stroke: new ol.style.Stroke( { 
            color: [0 , 58 , 128 , 1],
            width: 2
        })
    });
    
    
    var attribution = new ol.control.Attribution({
      collapsible: false
    });
    var mousePosition = new ol.control.MousePosition( { 
        coordinateFormat: ol.coordinate.createStringXY(4),
        projection: 'EPSG:4326',
        target: undefined,
        undefinedHTML: '&nbsp;'
    });
    var view = new ol.View({
        center: ol.proj.fromLonLat(mapCenter),
        zoom: zoom
    });
    var map = new ol.Map({
      controls: ol.control.defaults({ attribution: false }).extend([attribution]),
      target: 'map',
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
    
    function setPosition(pointNumber, lon, lat) {
        var lonlat3857 = ol.proj.transform([parseFloat(lon),parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');
        if (pointNumber == 1) {
            point1.setCoordinates (lonlat3857);
            view.setCenter(lonlat3857);
            /* add coordinates for second point, if not exists */
            var lo2 = $("#long_end").val();
            var la2 = $("#lat_end").val();
            if (lo2.length == 0 || la2.length == 0) {
                point2.setCoordinates(lonlat3857);
                numpoint = 2;
            } 
        } else {
            point2.setCoordinates (lonlat3857);
        }
    }
    
    map.addLayer(layer);
    var coordinates;
    var point1, point2;
    var point_feature1, point_feature2;
    var features = new Array();
    /*
     * Traitement de chaque localisation
     */
    /*console.log("Début de traitement de l'affichage du point");
    console.log("x : " + {$data.wgs84_x});
    console.log("y  : "+ {$data.wgs84_y});
    */
    
    point1 = new ol.geom.Point([{$data.long_start}, {$data.lat_start}]);
    point2 = new ol.geom.Point([{$data.long_end}, {$data.lat_end}]);
    // console.log("Coordonnées : "+coordinates);
    // console.log("point :" + point);
    point_feature1 = new ol.Feature ( {
        geometry: point1
    });
    point_feature2 = new ol.Feature ( {
        geometry: point2
    });
    point_feature1.setStyle(getStyle("{t}Début{/t}"));
    point_feature2.setStyle(getStyle("{t}fin{/t}"));
    features.push ( point_feature1) ;
    features.push (point_feature2);
    
    
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
    map.addLayer(layerPoint);
    map.addControl(mousePosition);

    if ( mapIsChange == true) {
        map.on('click', function(evt) {
            var lonlat3857 = evt.coordinate;
            var lonlat = ol.proj.transform(lonlat3857, 'EPSG:3857', 'EPSG:4326');
            var lon = lonlat[0];
            var lat = lonlat[1];
            setPosition(numpoint, lon, lat);
            if (numpoint == 1) {
                $("#long_start").val(lon);
                $("#lat_start").val(lat);
                numpoint = 2;
            } else {
                $("#long_end").val(lon);
                $("#lat_end").val(lat);
                numpoint = 1;
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
        setPosition(numpoint, lon, lat);
            if (numpoint == 1) {
                $("#long_start").val(lon);
                $("#lat_start").val(lat);
                numpoint = 2;
            } else {
                $("#long_end").val(lon);
                $("#lat_end").val(lat);
                numpoint = 1;
            }
      });   
   }
 });    
   
</script>