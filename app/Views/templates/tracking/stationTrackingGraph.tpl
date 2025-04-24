<script src="display/node_modules/d3/dist/d3.min.js"></script>
<script src="display/node_modules/c3/c3.min.js"></script>
<link rel="stylesheet" type="text/css" href="display/node_modules/c3/c3.min.css" />
<script>
  $(document).ready(function() {
    var chartData = JSON.parse('{$chartData}');
    var stations = JSON.parse('{$graphStations}');
    var graphdata = JSON.parse('{$graphdata}');
    var series = JSON.parse('{$series}');
    var regions = JSON.parse('{$regions}');
    var chart = c3.generate ({
      bindto: "#chart",
      data: {
        x: 'date',
        xFormat: '%Y-%m-%d %H:%M:%S',
        json: graphdata,
        keys: {
        "x": "date",
        "value": series
        },
        regions: regions
      },
      axis: {
        x: {
          type: 'timeseries',
          tick: {
            format: '%d/%m/%Y %H:%M',
            count: 5
          },
          label: "{t}Fonctionnement des stations{/t}",
        },
        y: {
          label: '{t}N° des stations{/t}',
          tick: {
            values: stations
          }
        }
      },
      grid: {
        y: {
          show: true
        }
      },
      zoom: {
        enabled:true,
        type: 'scroll', /* drag */
        extent: [10, 100]
      },
      line: {
        connectNull: true
      },
      size: {
        height:640
      }

    });
  });
</script>
