<script src="display/node_modules/c3/node_modules/d3/dist/d3.min.js"></script>
<script src="display/node_modules/c3/c3.min.js"></script>
<link rel="stylesheet" type="text/css" href="display/node_modules/c3/c3.min.css" />
<script>
  $(document).ready(function() {
   var chartData = JSON.parse('{$chartData}');
    var chart = c3.generate ({
      bindto: "#chart1",
      data: {
        x: 'x',
        xFormat: '%Y-%m-%d %H:%M:%S',
        columns: chartData
      },
      axis: {
        x: {
          type: 'timeseries',
          tick: {
            format: '%Y-%m-%d %H:%M:%S'
          }
        }
      }
    });
  });
</script>
<div class="col-lg-12">
  <div id="chart1"></div>
</div>
