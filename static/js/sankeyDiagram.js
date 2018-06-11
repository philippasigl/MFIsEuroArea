var svg
var canvas
var formatNumber
var sankey
var graph
var rankedNodes
//var width
//var height
var _links
var _linkData
var _nodeData
var _nodes
var _date
//var _cutOff in options.js
var _mode = 'default'
var _linkOpacity = 0.3
var _nodeOpacity = 1
var _nodeWidth = 15
var _nodePadding = 25
var _value
var dateArray
var x0positions

const init = () => {
    canvas = document.getElementById("sankeyChart")
    slider = document.getElementById("cutOffSlider")

   
    let valPerPeriod=sankey_values.length/Object.values(dates).length
    let startValSlider = 0
    setCutOffSlider(slider,startValSlider,valPerPeriod)
    
    svg = d3.select("svg"),
        width =canvas.getClientRects()[0].width-70,
        height = canvas.getClientRects()[0].height-110;

    dateArray = Object.values(dates)
    _date = dateArray[dateArray.length-1]
    _nodeData = _uniqueNodesAllPeriods
    //need to make a shallow copy to ensure d is not changed!
    _linkData = JSON.parse(JSON.stringify(sankey_values))
    _value = 'absolute'

    //find x0 positions for drawing
    x0positions=x0_positions(canvas.getClientRects()[0].width-70)
    draw()

    //record positions of nodes
    rankedNodes=get_node_ranking(graph.nodes)
    
    
}

const draw = () => {
    if (_mode != 'default') unrollOptions()
    else setOptions()
    construct_sankey()
    define_data()
}

const construct_sankey = () => {
    //remove former links
    if (typeof _links != 'undefined') _links.remove()
    if (typeof _nodes != 'undefined') _nodes.remove()
    
    formatNumber = d3.format(",.0f"),
        format = (d) => { return formatNumber(d) },
        color = d3.scaleOrdinal(d3.schemeCategory10);
    
    sankey = d3.sankey()
        .nodeWidth(_nodeWidth)
        .nodePadding(_nodePadding)
        .extent([[1, 1], [width - 1, height - 6]]);
    
    _links = svg.append("g")
        .attr("class", "links")
        .attr("fill", "none")
        .attr("stroke", "#000")
        //.attr("stroke-opacity", _linkOpacity)
      .selectAll("path");
    
    _nodes = svg.append("g")
        .attr("class", "nodes")
        .attr("font-family", "sans-serif")
        .attr("font-size", 10)
        .attr("fill-opacity",_nodeOpacity)
      .selectAll("g"); 
}

const id = (d) => { return d.id }

const define_data = (mode) => {
      
      //ensures non-numeric source and target ids for links work
      sankey.nodeId(id)
        
      if (_date==dateArray[dateArray.length-1]) sankey.iterations(100)
      else sankey.iterations(10)
      sankey.nodePadding(_nodePadding) 

      if (_mode!='default') data=unrollData()
      else data=set_data()
      
      graph=sankey(data) 

      //adjust node depth to level
      data.nodes.map((node) => {node.x0=x0positions[parseInt(node.id.slice(-1))]; node.x1=node.x0+_nodeWidth})

      _links = _links
        .data(data.links)
        .enter().append("path")
          .attr("d", d3.sankeyLinkHorizontal())
          .attr("stroke-width", function(d) { return Math.max(1, d.width); })
         //.attr("stroke-width", (d) => { return Math.max(1, d.width); })
         .attr("stroke", (d) =>{ return  d.color} )
         .attr("opacity", (d) => {return d.opacity})
    
      _links.append("title")
          .text(function(d) { 
              if (_mode=='default' && _value == 'absolute') 
                {return d.source.id.slice(0,-1) + " → " + d.target.id.slice(0,-1) + "\n" + (d.value).toFixed(2);}
               else if (_mode=='default' && _value == 'change') { return d.source.id.slice(0,-1) + " → " + d.target.id.slice(0,-1) + "\n" + (d.deltaPct*d.deltaSign).toFixed(2) +"%" }
               else if (_mode=='default' && _value == 'CAGR') { return d.source.id.slice(0,-1) + " → " + d.target.id.slice(0,-1) + "\n" + (d.cagr*d.cagrSign).toFixed(2) +"%" }
               else {return d.edge_type.slice(0,-1) + "\n" + (d.value).toFixed(2)}
             });
    
      _nodes = _nodes
        .data(data.nodes)   
        .enter().append("g");
   //  console.log(d3.select("g"))
      _nodes.append("rect")
      .attr("x", function(d) {return d.x0})
          .attr("y", function(d) { return d.y0; })
          .attr("height", function(d) { return d.y1 - d.y0; })
          .attr("width", function(d) { return d.x1 - d.x0; })
          //.attr("fill", function(d) { return color(d.id.replace(/ .*/, "")); })
          .attr("fill", (d) => { return d == _xHighlighted || d == _xHighlighted2 ? DARK_BLUE : COLORS[0]})
          .on("click", (d) => setHighlightedX(d))
         
      _nodes.append("text")
          .attr("x", function(d) { return d.x0 - 6; })
          .attr("y", function(d) { return (d.y1 + d.y0) / 2; })
          .attr("dy", "0.35em")
          .attr("text-anchor", "end")
          .text(function(d) { return d.id.slice(0,-1); })
        .filter(function(d) { return d.x0 < width / 2; })
          .attr("x", function(d) { return d.x1 + 6; })
          .attr("text-anchor", "start");
    
      _nodes.append("title")
          .text(function(d) { return d.id.slice(0,-1) + "\n" + format(d.value); });
    
}

const get_node_ranking = (nodes) => {
    let rankedNodes={}
    let xValues = getUniqueValues(nodes,'x0')
    xValues.forEach((val) => { 
            let xNodes = nodes.filter((node) => node['x0'] == val)
            let sortedNodes = sortByKey(xNodes,'y0')
            sortedNodes.map((node,idx) => rankedNodes[node.id]=idx)
    })
   
    return rankedNodes
}  

const x0_positions = (width) => {
    let levels =_uniqueNodesAllPeriods.map((node) => {return parseInt(node.id.slice(-1))})
    levels = getUniqueArrValues(levels)
    let x0positions = levels.map((level) => {return width/(levels.length-1)*level})
    return sortVals(x0positions)
  }

init()
set_cutOff()
switch_Level()
