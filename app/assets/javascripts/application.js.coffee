#= require jquery/jquery
#= require jquery_ujs
#= require jquery-idletimer/dist/idle-timer
#= require jQuery-Knob/js/jquery.knob
#= require momentjs/moment
#= require bootstrap/dist/js/bootstrap
#= require underscore/underscore
#= require backbone/backbone
#= require handlebars/handlebars
#= require thorax/thorax
#= require backbone_sync_rails
#= require d3/d3
#
#= require config
#= require population_chart
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require router
#= require_self

if Config.idleTimeoutEnabled
  $(document).idleTimer Config.idleTimeout
  $(document).on 'idle.idleTimer', ->
    $.ajax
      url: '/users/sign_out'
      type: 'DELETE'
      success: (result) -> window.location.href = '/logout.html'






