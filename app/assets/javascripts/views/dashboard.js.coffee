class Thorax.Views.Dashboard extends Thorax.View
  template: JST['dashboard']
  events:
    rendered: ->
      @$("[rel='tooltip']").tooltip()
