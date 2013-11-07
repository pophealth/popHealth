function populationChart()
{
    var width = 150, 
        height = 40,
        xScale = d3.scale.linear(),
        yScale = d3.scale.ordinal(),
        margin = {top:2, right:2, bottom:2, left:2},
        numerSpacing = 4,
        minWidth = 0;
    function my(selection)
    {
        selection.each(function(data){
            xScale
                .domain([0,data.patients])
                .range([minWidth, width - margin.left - margin.right - 3*minWidth])
                .clamp(true)
                .nice();
            yScale 
                .domain(["NUMER", "DENOM"])
                .range([margin.top, (height - margin.top - margin.bottom)/2])
            var svg = d3.select(this).selectAll("svg").data([data])
            var gEnter = svg.enter().append("svg").attr("width", this.width)
                .attr("height", this.height)
            

            var numer = gEnter.append("g")
                .append("rect")
                .attr("class", "numer")
                .attr("width", xScale(data.NUMER))
                .attr("height",(height - margin.top - margin.bottom)/2 - numerSpacing/2)
                .attr("y", yScale("NUMER"))
                .attr("x", margin.left)
            var denom = gEnter.append("g")
                .attr("class", "denom")
                
            denom.append("rect")
                .attr("class", "denom")
                .attr("width", xScale(data.DENOM))
                .attr("height",(height - margin.top - margin.bottom)/2 )
                .attr("y", yScale("DENOM")+ numerSpacing/2)
                .attr("x", margin.left)

            if (data.DENEX > 0) {
                denom.append("rect")
                    .attr("class", "denex")
                    .attr("width", xScale(data.DENEX))
                    .attr("height",(height - margin.top - margin.bottom)/2 )
                    .attr("y", yScale("DENOM")+ numerSpacing/2)
                    .attr("x", xScale(data.DENOM))
            }
            if (data.DENEXC >0) {
                denom.append("rect")
                    .attr("class", "denexc")
                    .attr("width", xScale(data.DENEXC))
                    .attr("height",(height - margin.top - margin.bottom)/2 )
                    .attr("y", yScale("DENOM")+ numerSpacing/2)
                    .attr("x", xScale(data.DENOM)+xScale(data.DENEX))
            };
        })

    }

    my.numerSpacing = function(_)
    {
        if (!arguments.length) return numerSpacing
        numerSpacing = _;
        return my;
    }

    my.minWidth = function(_)
    {
        if (!arguments.length) return minWidth
        minWidth = _;
        return my;
    }

    my.width = function(_)
    {
        if (!arguments.length) return width
        width = _;
        return my;
    }


    my.height = function(_)
    {
        if (!arguments.length) return height
        height = _;
        return my;
    }

    my.x = function(_)
    {
        if (!arguments.length) return xValue
        xValue = _;
        return my;
    }

    my.y = function(_)
    {
        if (!arguments.length) return yValue
        yValue = _;
        return my;
    }

    my.margin = function(_)
    {
        if (!arguments.length) return margin
        margin = _;
        return my;
    }

    return my;

}
