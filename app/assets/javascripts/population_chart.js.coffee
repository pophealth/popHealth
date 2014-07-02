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

      return if data.DENOM is 0

      boxGroup = gEnter.append('g')

      boxGroup.append('rect')
        .attr('class', 'denom')
        .attr('width', xScale(data.DENOM))
        .attr('height', height)
        .attr('x', margin.left)
        # popover reports on the performance denominator, which doesn't include exclusions/exceptions
        .attr('data-content', "Denominator: #{data.performanceDenominator}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body')

      boxGroup.append('rect')
        .attr('class', 'numer')
        .attr('width', xScale(data.NUMER))
        .attr('height', height)
        .attr('x', margin.left)
        .attr('data-content', "Numerator: #{data.NUMER}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body')

      boxGroup.append('rect')
        .attr('class', 'denex')
        .attr('width', xScale(data.DENEX))
        .attr('height', height)
        .attr('x', margin.left + xScale(data.NUMER))
        .attr('data-content', "Exclusion: #{data.DENEX}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body') if data.DENEX > 0

      boxGroup.append('rect')
        .attr('class', 'denexc')
        .attr('width', xScale(data.DENEXCEP))
        .attr('height', height)
        .attr('x', margin.left + xScale(data.NUMER + data.DENEX))
        .attr('data-content', "Exceptions: #{data.DENEXCEP}")
        .attr('data-trigger', "hover focus")
        .attr('data-container', 'body') if data.DENEXCEP > 0

      if data.lower_is_better?
        arrow = gEnter.append('g')
        arrowOffset = if data.lower_is_better then margin.left else margin.left + boxGroup.node().getBBox().width
        arrow.append('path')
          .attr('class', 'arrow')
          .attr('d', d3.svg.symbol().size(240).type('triangle-up'))
          .attr('transform', "translate(#{arrowOffset}, #{height + 12})")

  width = 150
  height = 20
  maximumValue = 100
  xScale = d3.scale.linear()
  margin =
    top: 2
    right: 4
    bottom: 2
    left: 4

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
