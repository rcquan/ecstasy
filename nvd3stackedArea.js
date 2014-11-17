<div id = 'nvd3stacked' class = 'rChart nvd3'></div>
<script type='text/javascript'>
 $(document).ready(function(){
      drawnvd3stacked()
    });
    function drawnvd3stacked(){
      var opts = {
 "dom": "nvd3stacked",
"width":    800,
"height":    400,
"x": "year",
"y": "proportion",
"group": "mdma",
"type": "stackedAreaChart",
"id": "nvd3stacked"
},
        data = [
 {
 "year": 1999,
"mdma": "Pure MDMA",
"count": 35,
"proportion": 0.5072463768116
},
{
 "year": 1999,
"mdma": "More MDMA",
"count": 4,
"proportion": 0.05797101449275
},
{
 "year": 1999,
"mdma": "Less MDMA",
"count": 1,
"proportion": 0.01449275362319
},
{
 "year": 1999,
"mdma": "No MDMA",
"count": 29,
"proportion": 0.4202898550725
},
{
 "year": 2000,
"mdma": "Pure MDMA",
"count": 152,
"proportion": 0.4564564564565
},
{
 "year": 2000,
"mdma": "More MDMA",
"count": 8,
"proportion": 0.02402402402402
},
{
 "year": 2000,
"mdma": "Less MDMA",
"count": 7,
"proportion": 0.02102102102102
},
{
 "year": 2000,
"mdma": "No MDMA",
"count": 166,
"proportion": 0.4984984984985
},
{
 "year": 2001,
"mdma": "Pure MDMA",
"count": 165,
"proportion": 0.4969879518072
},
{
 "year": 2001,
"mdma": "More MDMA",
"count": 11,
"proportion": 0.03313253012048
},
{
 "year": 2001,
"mdma": "Less MDMA",
"count": 22,
"proportion": 0.06626506024096
},
{
 "year": 2001,
"mdma": "No MDMA",
"count": 132,
"proportion": 0.3975903614458
},
{
 "year": 2002,
"mdma": "Pure MDMA",
"count": 98,
"proportion": 0.3255813953488
},
{
 "year": 2002,
"mdma": "More MDMA",
"count": 14,
"proportion": 0.04651162790698
},
{
 "year": 2002,
"mdma": "Less MDMA",
"count": 40,
"proportion": 0.1328903654485
},
{
 "year": 2002,
"mdma": "No MDMA",
"count": 143,
"proportion": 0.4750830564784
},
{
 "year": 2003,
"mdma": "Pure MDMA",
"count": 58,
"proportion": 0.3741935483871
},
{
 "year": 2003,
"mdma": "More MDMA",
"count": 8,
"proportion": 0.05161290322581
},
{
 "year": 2003,
"mdma": "Less MDMA",
"count": 18,
"proportion": 0.1161290322581
},
{
 "year": 2003,
"mdma": "No MDMA",
"count": 69,
"proportion": 0.4451612903226
},
{
 "year": 2004,
"mdma": "Pure MDMA",
"count": 16,
"proportion": 0.1006289308176
},
{
 "year": 2004,
"mdma": "More MDMA",
"count": 23,
"proportion": 0.1446540880503
},
{
 "year": 2004,
"mdma": "Less MDMA",
"count": 29,
"proportion": 0.1823899371069
},
{
 "year": 2004,
"mdma": "No MDMA",
"count": 88,
"proportion": 0.5534591194969
},
{
 "year": 2005,
"mdma": "Pure MDMA",
"count": 39,
"proportion": 0.2867647058824
},
{
 "year": 2005,
"mdma": "More MDMA",
"count": 23,
"proportion": 0.1691176470588
},
{
 "year": 2005,
"mdma": "Less MDMA",
"count": 24,
"proportion": 0.1764705882353
},
{
 "year": 2005,
"mdma": "No MDMA",
"count": 49,
"proportion": 0.3602941176471
},
{
 "year": 2006,
"mdma": "Pure MDMA",
"count": 8,
"proportion": 0.1739130434783
},
{
 "year": 2006,
"mdma": "More MDMA",
"count": 5,
"proportion": 0.1086956521739
},
{
 "year": 2006,
"mdma": "Less MDMA",
"count": 15,
"proportion": 0.3260869565217
},
{
 "year": 2006,
"mdma": "No MDMA",
"count": 13,
"proportion": 0.2826086956522
},
{
 "year": 2007,
"mdma": "Pure MDMA",
"count": 10,
"proportion": 0.1470588235294
},
{
 "year": 2007,
"mdma": "More MDMA",
"count": 5,
"proportion": 0.07352941176471
},
{
 "year": 2007,
"mdma": "Less MDMA",
"count": 12,
"proportion": 0.1764705882353
},
{
 "year": 2007,
"mdma": "No MDMA",
"count": 29,
"proportion": 0.4264705882353
},
{
 "year": 2008,
"mdma": "Pure MDMA",
"count": 7,
"proportion": 0.1521739130435
},
{
 "year": 2008,
"mdma": "More MDMA",
"count": 4,
"proportion": 0.08695652173913
},
{
 "year": 2008,
"mdma": "Less MDMA",
"count": 7,
"proportion": 0.1521739130435
},
{
 "year": 2008,
"mdma": "No MDMA",
"count": 23,
"proportion":            0.5
},
{
 "year": 2009,
"mdma": "Pure MDMA",
"count": 10,
"proportion": 0.07518796992481
},
{
 "year": 2009,
"mdma": "More MDMA",
"count": 12,
"proportion": 0.09022556390977
},
{
 "year": 2009,
"mdma": "Less MDMA",
"count": 8,
"proportion": 0.06015037593985
},
{
 "year": 2009,
"mdma": "No MDMA",
"count": 91,
"proportion": 0.6842105263158
},
{
 "year": 2010,
"mdma": "Pure MDMA",
"count": 43,
"proportion": 0.2925170068027
},
{
 "year": 2010,
"mdma": "More MDMA",
"count": 26,
"proportion": 0.1768707482993
},
{
 "year": 2010,
"mdma": "Less MDMA",
"count": 6,
"proportion": 0.04081632653061
},
{
 "year": 2010,
"mdma": "No MDMA",
"count": 68,
"proportion": 0.4625850340136
},
{
 "year": 2011,
"mdma": "Pure MDMA",
"count": 37,
"proportion": 0.1681818181818
},
{
 "year": 2011,
"mdma": "More MDMA",
"count": 30,
"proportion": 0.1363636363636
},
{
 "year": 2011,
"mdma": "Less MDMA",
"count": 22,
"proportion":            0.1
},
{
 "year": 2011,
"mdma": "No MDMA",
"count": 113,
"proportion": 0.5136363636364
},
{
 "year": 2012,
"mdma": "Pure MDMA",
"count": 39,
"proportion": 0.1604938271605
},
{
 "year": 2012,
"mdma": "More MDMA",
"count": 21,
"proportion": 0.08641975308642
},
{
 "year": 2012,
"mdma": "Less MDMA",
"count": 11,
"proportion": 0.04526748971193
},
{
 "year": 2012,
"mdma": "No MDMA",
"count": 120,
"proportion": 0.4938271604938
},
{
 "year": 2013,
"mdma": "Pure MDMA",
"count": 59,
"proportion": 0.2543103448276
},
{
 "year": 2013,
"mdma": "More MDMA",
"count": 17,
"proportion": 0.07327586206897
},
{
 "year": 2013,
"mdma": "Less MDMA",
"count": 6,
"proportion": 0.02586206896552
},
{
 "year": 2013,
"mdma": "No MDMA",
"count": 103,
"proportion": 0.4439655172414
},
{
 "year": 2014,
"mdma": "Pure MDMA",
"count": 69,
"proportion": 0.3209302325581
},
{
 "year": 2014,
"mdma": "More MDMA",
"count": 15,
"proportion": 0.06976744186047
},
{
 "year": 2014,
"mdma": "Less MDMA",
"count": 7,
"proportion": 0.03255813953488
},
{
 "year": 2014,
"mdma": "No MDMA",
"count": 104,
"proportion": 0.4837209302326
}
]

      if(!(opts.type==="pieChart" || opts.type==="sparklinePlus" || opts.type==="bulletChart")) {
        var data = d3.nest()
          .key(function(d){
            //return opts.group === undefined ? 'main' : d[opts.group]
            //instead of main would think a better default is opts.x
            return opts.group === undefined ? opts.y : d[opts.group];
          })
          .entries(data);
      }

      if (opts.disabled != undefined){
        data.map(function(d, i){
          d.disabled = opts.disabled[i]
        })
      }

      nv.addGraph(function() {
        var chart = nv.models[opts.type]()
          .width(opts.width)
          .height(opts.height)

        if (opts.type != "bulletChart"){
          chart
            .x(function(d) { return d[opts.x] })
            .y(function(d) { return d[opts.y] })
        }










       d3.select("#" + opts.id)
        .append('svg')
        .datum(data)
        .transition().duration(500)
        .call(chart);

       nv.utils.windowResize(chart.update);
       return chart;
      });
    };
</script>