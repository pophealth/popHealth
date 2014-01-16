window.PopHealth ||= {}
PopHealth.viz ||= {}
PopHealth.viz.populationChart = ->
  my = (selection) ->
    selection.each (data) ->
      xScale.domain([0, maximumValue]).range([minWidth, width - margin.left - margin.right - 3 * minWidth]).clamp(true).nice()
      yScale.domain(['NUMER', 'DENOM']).range [margin.top, height-margin.bottom-barHeight]
      svg = d3.select(this).selectAll('svg').data([data])
      gEnter = svg.enter().append('svg')
        .attr('viewBox', "0 0 #{width} #{height}")
        .attr('preserveAspectRatio', 'none')
      numer = gEnter.append('g').append('rect')
        .attr('class', 'numer')
        .attr('width', xScale(data.NUMER))
        .attr('height', barHeight)
        .attr('y', yScale('NUMER'))
        .attr('x', margin.left)
        .attr('data-placement', "top")
        .attr('data-content', "Numerator: #{data.NUMER}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body')

      denom = gEnter.append('g')
        .attr('class', 'denom')
      denom.append('rect')
        .attr('class', 'denom')
        .attr('width', xScale(data.performanceDenominator))
        .attr('height', barHeight)
        .attr('y', yScale('DENOM'))
        .attr('x', margin.left)
        .attr('data-placement', "bottom")
        .attr('data-content', "Denominator: #{data.performanceDenominator}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body')
      denom.append('rect')
        .attr('class', 'denex')
        .attr('width', xScale(data.DENEX))
        .attr('height', barHeight)
        .attr('y', yScale('DENOM'))
        .attr('x', xScale(data.performanceDenominator))
        .attr('data-placement', "bottom")
        .attr('data-content', "Exclusion: #{data.DENEX}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body') if data.DENEX > 0

      denom.append('rect')
        .attr('class', 'denexc')
        .attr('width', xScale(data.DENEXCEP))
        .attr('height', barHeight)
        .attr('y', yScale('DENOM'))
        .attr('x', xScale(data.performanceDenominator) + xScale(data.DENEX))
        .attr('data-placement', "bottom")
        .attr('data-content', "Exceptions: #{data.DENEXCEP}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body') if data.DENEXCEP > 0


  width = 150
  height = 40
  maximumValue = 100
  xScale = d3.scale.linear()
  yScale = d3.scale.ordinal()
  margin =
    top: 2
    right: 2
    bottom: 2
    left: 2

  barHeight = 18
  minWidth = 0
  my.barHeight = (_) ->
    return barHeight unless arguments.length
    barHeight = _
    my

  my.minWidth = (_) ->
    return minWidth unless arguments.length
    minWidth = _
    my

  my.width = (_) ->
    return width unless arguments.length
    width = _
    my

  my.height = (_) ->
    return height unless arguments.length
    height = _
    my

  my.x = (_) ->
    return xValue unless arguments.length
    xValue = _
    my

  my.y = (_) ->
    return yValue unless arguments.length
    yValue = _
    my

  my.margin = (_) ->
    return margin unless arguments.length
    margin = _
    my

  my.maximumValue = (_) ->
    return maximumValue unless arguments.length
    maximumValue = _
    my

  my
