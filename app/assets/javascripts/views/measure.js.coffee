class Thorax.Views.MeasureView extends Thorax.View
  template: JST['measures/show']
  events:
    rendered: ->
      @$('.dial').knob()
      myChart = PopHealth.viz.populationChart().width(125).height(50).numerSpacing(2).maximumValue(PopHealth.patientCount)
      select = d3.select(@el).select('#test')
        .datum(NUMER: 5, DENOM: 7, DENEX: 2, DENEXCEP: 6)
        .call(myChart)


