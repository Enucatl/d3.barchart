if not d3.chart?
    d3.chart = {}

d3.chart.barchart = ->
    margin = {top: 20, right: 20, bottom: 40, left: 70}
    width = 900
    height = 600
    bar_width = 10
    x_value = (d, i) -> d
    y_value = (d, i) -> d
    x_scale = d3.scale.linear()
    y_scale = d3.scale.linear()
    x_axis = d3.svg.axis()
        .scale x_scale 
        .orient "bottom"
    y_axis = d3.svg.axis()
        .scale y_scale 
        .orient "left"
    x_title = undefined
    y_title = undefined
    n_bins = 100
    chart = (selection) ->
        selection.each (data) ->
                 
            #update scales
            x_scale
                .range [0, width - margin.left - margin.right]
            y_scale
                .range [height - margin.top - margin.bottom, 0]

            #select the svg if it exists
            svg = d3.select this
                .selectAll "svg"
                .data [data]

            #otherwise create the skeletal chart
            g_enter = svg.enter()
                .append "svg"
                .append "g"
            g_enter.append "g"
                .classed "x axis", true
                .append "text"
                .classed "label", true
                .attr "x", width - margin.right - margin.left
                .attr "y", margin.bottom - 6
                .style "text-anchor", "end"
                .text x_title
            g_enter.append "g"
                .classed "y axis", true
                .append "text"
                .classed "label", true
                .attr "y", -margin.left + 6
                .attr "transform", "rotate(-90)"
                .attr "dy", ".71em"
                .style "text-anchor", "end"
                .text y_title
            g_enter.append "g"
                .classed "histogram", true

            #update the dimensions
            svg
                .attr "width", width
                .attr "height", height

            #update position
            g = svg.select "g"
                .attr "transform", "translate(#{margin.left}, #{margin.top})"

            layout = data.map (d, i) ->
                {
                    x: x_value(d, i)
                    y: y_value(d, i)
                }

            y_scale.domain d3.extent layout, (d) -> d.y
            x_scale.domain d3.extent layout, (d) -> d.x

            bars = g.select "g.histogram"
                .selectAll "rect"
                .data layout

            bars
                .enter()
                .append "rect"

            bars
                .classed "bar", true
                .attr "x", (d) -> x_scale d.x
                .attr "width", bar_width
                .attr "height", (d) -> height - y_scale(d.y) - margin.top - margin.bottom
                .transition()
                .attr "y", (d) -> y_scale d.y

            bars
                .exit()
                .transition()
                .remove()

            #update axes
            g.select ".x.axis"
                .attr "transform", "translate(0, #{y_scale.range()[0]})"
                .call x_axis

            g.select ".y.axis"
                .transition()
                .call y_axis

    chart.bar_width = (value) ->
        if not arguments.length
            return bar_width
        bar_width = value
        chart

    chart.width = (value) ->
        if not arguments.length
            return width
        width = value
        chart

    chart.height = (value) ->
        if not arguments.length
            return height
        height = value
        chart

    chart.margin = (value) ->
        if not arguments.length
            return margin
        margin = value
        chart

    chart.x_value = (v) ->
        if not arguments.length
            return x_value
        x_value = v
        chart

    chart.y_value = (v) ->
        if not arguments.length
            return y_value
        y_value = v
        chart

    chart.x_title = (value) ->
        if not arguments.length
            return x_title
        x_title = value
        chart

    chart.y_title = (value) ->
        if not arguments.length
            return y_title
        y_title = value
        chart

    chart.x_scale = (value) ->
        if not arguments.length
            return x_scale
        x_scale = value
        chart

    chart.n_bins = (value) ->
        if not arguments.length
            return n_bins
        n_bins = value
        chart

    chart.y_scale = (value) ->
        if not arguments.length
            return y_scale
        y_scale = value
        chart

    chart
