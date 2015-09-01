window.PopHealth ||= {}
PopHealth.viz ||= {}
PopHealth.viz.providerChart = ->
  width = 800
  height = 180
  duration = 500
  depth = {}
  nodeId = 0

  my = (selection) ->
    cluster = d3.layout.tree().size([width, height])
    selection.each (data) ->
      highlight = (d, value) =>
        links = d3.selectAll($("path.link[target=#{d.id}]"))
        if links.node()? then links.classed("active", value)
        if d.parent? and value then highlight(d.parent, value)

      click = (d) =>
        if Config.OPML
          window.location.hash = "providers/#{d._id}"
        else
          if !(d._id == PopHealth.rootProvider.get("_id") and PopHealth.currentUser.get("staff_role"))
            window.location.hash = "providers/#{d._id}"
        return
        # This code is not currently used, it is to handle collapsing and opening
        if not d.loaded
          d3.json "api/providers/#{d._id}", (children) ->
            d.children = children.children
            d.loaded = true
            d.active = true
            d.size = 6
            update(d)
        if d.children? or d.loaded
          d.active = false
          d._children = d.children
          d.children = null
          d.parent?.children.forEach((d) -> d.hidden = false)
          d.size = 3.5
          highlight(d,false)

        else if d._children?
          highlight(d,true)
          d.active=true
          d.size = 6
          d.parent?.children.forEach((d) ->
            d.hidden = true
          )
          d.hidden = false
          d.children = d._children
          d._children = null

        update(d)
      update = (source) =>
        nodes = cluster.nodes(root)
        links = cluster.links(nodes)
        cluster.separation((a,b) -> 25)
        heightScale = d3.scale.linear()
          .range([30,height-60])
          .domain(d3.extent(nodes, (d) -> d.depth))
        widthScale = d3.scale.linear()
          .range([0, width - 90])
          .domain([0,width])
        # Normalize for constant height
        nodes.forEach (d) ->
          d.y = heightScale(d.depth)
          d.x = widthScale(d.x)
          d.size ?= 8

        node = svg.selectAll("g.node")
          .data(nodes, (d) -> d.id || d.id = ++nodeId)

        nodeEnter = node.enter().append("g")
          .classed("node", true)
          .classed("active", (d) -> d.active)
          .attr("id", (d) -> d._id)
          .attr("transform", "translate(#{source.x0}, #{source.y0})")
          .on("click", click)
        svg.selectAll(".node:not(.active)")
          .attr('data-placement', "bottom")
          .attr('data-content', (d) -> "#{d.cda_identifiers[0].root} #{d.cda_identifiers[0].extension} #{d.given_name}")
          .attr('data-trigger', "hover focus")
          .attr('data-container', '#providerChart')



        nodeEnter.append("circle")
          .attr("r", 1e-6)
          .classed("active", (d) -> d.active)


        nodeEnter.append("text")
          .transition().duration(duration)
          .attr("transform", "rotate(45, -9, 4.5)")
          .style("fill-opacity", 1.0)
          .attr("width")


        nodeUpdate = node.transition()
          .duration(duration)
          .attr("transform", (d) -> "translate(#{d.x}, #{d.y})")
        nodeUpdate.select("circle")
          .attr("r", (d) -> d.size)

        nodeUpdate.select("text")
          .text((d) -> if d.active then "#{d.cda_identifiers?[0].root || ""} #{d.cda_identifiers?[0].extension || ""} #{d.given_name}" else "#{d.cda_identifiers?[0].root || ""} #{d.cda_identifiers?[0].extension || ""}")
          .attr("transform", (d) -> if d.active then "translate(25) rotate(0)" else "translate(0,15) rotate(30)")


        nodeExit = node.exit()
          .transition()
          .duration(duration)
          .attr("transform", (d) -> "translate(#{source.x}, #{source.y})")
          .remove()
        node.exit().select("text").remove()

        nodeExit.select("circle")
          .attr("r", 1e-6)


        link = svg.selectAll("path.link")
          .data(links, (d) -> d.target.id)

        link.enter().insert("path", "g")
          .classed("link", true)
          .attr("target", (d) -> d.target.id)
          .attr("d", (d)->
            o = {x: source.x0, y: source.y0}
            return diagonal({source: o, target: o}))



        link.transition()
          .duration(duration)
          .attr("d", diagonal)


        link.exit().transition()
          .duration(duration)
          .attr("d", (d)->
            o = {x: source.x, y: source.y}
            return diagonal({source: o, target: o}))
          .remove()

        nodes.forEach (d) ->
          d.x0 = d.x
          d.y0 = d.y




      svg = d3.select(this).append("svg")
        .attr("width", width)
        .attr("height", height)
      diagonal = d3.svg.diagonal()
        .projection((d) -> [d.x, d.y])
      if data.parent_id?
        data.active = true
        data = {given_name: "#{data.parent.cda_identifiers?[0].root||""} #{data.parent.cda_identifiers?[0].extension||""} #{data.parent.given_name}", _id: data.parent_id, children: [data]}
      root = data
      root.active = true
      root.size = 8
      root.x0 = width/2
      root.y0 = height/2

      collapse = (d) ->
        if d.children?
          d._children = d.children
          d.children = null
          d._children.foreach(collapse)
        else
          d.children = d._children
          d._children = null

      update(root)

  my.width = (_) ->
    return width unless arguments.length
    width = _
    my

  my.height = (_) ->
    return height unless arguments.length
    height = _
    my

  my.duration = (_) ->
    return duration unless arguments.length
    duration = _
    my

  my.depth = (_) ->
    return depth unless arguments.length
    depth = _
    my

  my
