<div id="mapSequences" class="map"></div>

<script>
    var mapS = setMap("mapSequences");
    var markers = new L.FeatureGroup();
    var latlngs = [];
    {foreach $sequences as $sequence}
        var lat = parseFloat("{$sequence.ambience_lat}");
        var long = parseFloat("{$sequence.ambience_long}");
        if (! isNaN(long) && ! isNaN(lat)) {
            var latlong = [lat, long];
            latlngs.push(latlong);
            var sequenceNumber = "{$sequence.sequence_number}";
            var id = "{$sequence.sequence_id}";
            var sequenceDate = "{$sequence.date_start}";
            var marker = L.marker(latlong, {
                /*title:  sequenceNumber+ ": " + sequenceDate,*/
            }).bindPopup('<a href="&module=sequenceDisplay?sequence_id='+id+'">' + sequenceNumber + ": " + sequenceDate + "<a/>")
            .bindTooltip(sequenceNumber, {
                permanent: true,
                 });
            marker.addTo(markers);
        }
    {/foreach}
    if (latlngs.length == 1) {
        mapData["mapDefaultLong"] = latlngs[0][1];
        mapData["mapDefaultLat"] = latlngs[0][0];
    }
    mapDisplay(mapS);
    markers.addTo(mapS);
</script>