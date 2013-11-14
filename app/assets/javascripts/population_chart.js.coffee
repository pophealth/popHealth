window.PopHealth ||= {}
PopHealth.viz ||= {}
PopHealth.viz.populationChart = ->
  my = (selection) ->
    selection.each (data) ->
      xScale.domain([0, maximumValue]).range([minWidth, width - margin.left - margin.right - 3 * minWidth]).clamp(true).nice()
      yScale.domain(['NUMER', 'DENOM']).range [margin.top, (height - margin.top - margin.bottom) / 2]
      svg = d3.select(this).selectAll('svg').data([data])
      gEnter = svg.enter().append('svg').attr('width', @width).attr('height', @height)
      numer = gEnter.append('g').append('rect').attr('class', 'numer').attr('width', xScale(data.NUMER)).attr('height', (height - margin.top - margin.bottom) / 2 - numerSpacing / 2).attr('y', yScale('NUMER')).attr('x', margin.left)
      denom = gEnter.append('g').attr('class', 'denom')
      denom.append('rect').attr('class', 'denom').attr('width', xScale(data.DENOM)).attr('height', (height - margin.top - margin.bottom) / 2).attr('y', yScale('DENOM') + numerSpacing / 2).attr 'x', margin.left
      denom.append('rect').attr('class', 'denex').attr('width', xScale(data.DENEX)).attr('height', (height - margin.top - margin.bottom) / 2).attr('y', yScale('DENOM') + numerSpacing / 2).attr 'x', xScale(data.DENOM) if data.DENEX > 0
      denom.append('rect').attr('class', 'denexc').attr('width', xScale(data.DENEXCEP)).attr('height', (height - margin.top - margin.bottom) / 2).attr('y', yScale('DENOM') + numerSpacing / 2).attr 'x', xScale(data.DENOM) + xScale(data.DENEX) if data.DENEXCEP > 0

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

  numerSpacing = 4
  minWidth = 0
  my.numerSpacing = (_) ->
    return numerSpacing unless arguments.length
    numerSpacing = _
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