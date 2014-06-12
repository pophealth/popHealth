window.PopHealth ||= {}
PopHealth.viz ||= {}
PopHealth.viz.populationChart = ->
  my = (selection) ->
    selection.each (data) ->
      xScale.domain([0, maximumValue]).range([minWidth, width - margin.left - margin.right - 3 * minWidth]).clamp(true).nice()
      svg = d3.select(this).selectAll('svg').data([data])
      gEnter = svg.enter().append('svg')
        .attr('viewBox', "0 0 #{width} #{height}")
        .attr('preserveAspectRatio', 'xMidYMid meet')
      numer = gEnter.append('g').append('rect')
        .attr('class', 'numer')
        .attr('width', xScale(data.NUMER))
        .attr('height', height)
        .attr('x', margin.left)
        .attr('data-content', "Numerator: #{data.NUMER}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body')

      denom = gEnter.append('g')
        .attr('class', 'denom')

      denom.append('rect')
        .attr('class', 'denom')
        .attr('width', xScale(data.performanceDenominator - data.NUMER))
        .attr('height', height)
        .attr('x', margin.left + xScale(data.NUMER + data.DENEX + data.DENEXCEP))
        .attr('data-content', "Denominator: #{data.performanceDenominator}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body')

      denom.append('rect')
        .attr('class', 'denex')
        .attr('width', xScale(data.DENEX))
        .attr('height', height)
        .attr('x', margin.left + xScale(data.NUMER))
        .attr('data-content', "Exclusion: #{data.DENEX}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body') if data.DENEX > 0

      denom.append('rect')
        .attr('class', 'denexc')
        .attr('width', xScale(data.DENEXCEP))
        .attr('height', height)
        .attr('x', margin.left + xScale(data.NUMER + data.DENEX))
        .attr('data-content', "Exceptions: #{data.DENEXCEP}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body') if data.DENEXCEP > 0


  width = 150
  height = 20
  maximumValue = 100
  xScale = d3.scale.linear()
  margin =
    top: 2
    right: 2
    bottom: 2
    left: 2

  minWidth = 0

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
