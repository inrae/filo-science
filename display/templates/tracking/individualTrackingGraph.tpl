<script src="display/node_modules/d3/dist/d3.min.js"></script>
<script src="display/node_modules/c3/c3.min.js"></script>
<link rel="stylesheet" type="text/css" href="display/node_modules/c3/c3.min.css" />
<script>
  $(document).ready(function() {
    var chartData2 = JSON.parse('{$chartData2}');
    var stations = JSON.parse('{$stations}');
    var graphdata = JSON.parse('{$graphdata}');
    var series = JSON.parse('{$series}');
    var regions = JSON.parse('{$regions}');
    var chart2 = c3.generate ({
      bindto: "#chart2",
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
          label: "{t}Présence sur la station{/t}",
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
      }

    });
  });
</script>
<div class="row">
  <div id="chart2"></div>
</div>
