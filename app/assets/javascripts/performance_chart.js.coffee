window.PopHealth ||= {}
PopHealth.viz ||= {}
PopHealth.viz.performanceChart = ->
  width = 80
  margin =
    top: 2
    right: 2
    bottom: 2
    left: 2

  lineThickness = 4
  my = (selection) ->
    selection.each (data) ->
      svg = d3.select(this).selectAll('svg').data([data])
      gEnter = svg.enter().append('svg')
        .attr('viewBox', "0 0 #{width} #{width}")
        .attr('height', width)
        # .attr('preserveAspectRatio', 'none')
      arcScale = d3.scale.linear().domain([0,100]).range([0, 2*Math.PI])
      outerRadius = (width - margin.right - margin.left)/2
      innerRadius = outerRadius - lineThickness
      baseArc = d3.svg.arc()
        .innerRadius(innerRadius)
        .outerRadius(outerRadius)
        .startAngle(0)
        .endAngle(arcScale(100))
      dataArc = d3.svg.arc()
        .innerRadius(innerRadius)
        .outerRadius(outerRadius)
        .startAngle(0)
        .endAngle(arcScale(data.performanceRate()))
      gEnter.append("path")
        .attr("d", baseArc)
        .attr("transform", "translate(#{width/2}, #{width/2})")
        .classed("base", true)
      gEnter.append("path")
        .attr("d", dataArc)
        .attr("transform", "translate(#{width/2}, #{width/2})")
        .classed("performance", true)
      gEnter.append("text")
        .text(data.performanceRate())
        .attr("transform", "translate(#{width/2}, #{width/2})")
        .attr("text-anchor", "middle")
        .classed("percentage", true)
        .append("tspan")
        .text("%")
        .attr("text-anchor", "middle")
        .classed("percentage", true)
        .classed("unit", true)


  my.lineThickness = (_) ->
    return lineThickness unless arguments.length
    lineThickness = _
    my

  my.width = (_) ->
    return width unless arguments.length
    width = _
    my

  my.margin = (_) ->
    return margin unless arguments.length
    margin = _
    my

  my
