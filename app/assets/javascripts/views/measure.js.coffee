class Thorax.Views.MeasureView extends Thorax.View
  template: JST['measures/show']
  events:
    rendered: ->
      @$(".dial").knob({width: 75, readOnly: true, thickness:.1 ,inputColor:"#37858D", fgColor:"#37858D"})
      myChart = populationChart()
      select = d3.select("#test")
        .datum({patients: 15, NUMER:5, DENOM:7, DENEX:2, DENEXC:6})
        .call(myChart)
      
    
