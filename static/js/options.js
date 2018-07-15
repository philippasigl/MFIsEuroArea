var _cutOff = 0
var _xHighlighted = 0
var _xHighlighted2 = 0
var _ratio = 0
var _xHighlightedName

const switch_value = () => {
    _value = document.getElementById('value').value
    draw()
}

const switch_date = () => {
    _date = document.getElementById('date').value
    draw()
}

const set_data = () => {
    let shallowCopyD = JSON.parse(JSON.stringify(sankey_values))
    let _linkDataLong = shallowCopyD.filter((link) => link.time == _date)
    _linkData=cut_links(_linkDataLong)
    _linkData.forEach(linkWidthAndColor)
    setLinkOpacity(_linkData)
    _nodeData = select_nodes(_linkData)
    order_nodes(_nodeData)  
    var data = {nodes: _nodeData, links: _linkData}
    return data
}

const select_nodes = (linkData) => {
    let usedNodesSourceIDs = linkData.map((link) => {return link.source})
    let usedNodesTargetIDs = linkData.map((link) => {return link.target})
    let usedNodesIDs = usedNodesSourceIDs.concat(usedNodesTargetIDs)
    usedNodes = _uniqueNodesAllPeriods.filter((node) => usedNodesIDs.indexOf(node.id)!=-1)
    return usedNodes
}

//put nodes in same order as (first) reference period
const order_nodes = (nodes) => {
    if (_date==dateArray[dateArray.length-1]) return
    nodes.map((node) => {
        if (typeof rankedNodes[node.id] != 'undefined') node.pos=rankedNodes[node.id]
        else node.pos=nodes.length+1
    })
    
    sortByKey(nodes,'pos')
}

const cut_links = (links) => {
    sortByKey(links,'absValue')
    slicedLinks=links.slice(_cutOff)
    return slicedLinks
}

const set_cutOff = () => cutOffSlider.noUiSlider.on('change', (values) => {
    _cutOff = values[0]
    draw()
})

const setOptions = () => {
    _linkOpacity = 0.2
    _nodeOpacity = 1
    _nodeWidth = 15
    _nodePadding = 30
}

const linkWidthAndColor = (link) => {
   if (_value=='absolute') link.value = link.absValue
   else if (_value=='change') link.value = link.absValue
   else if (_value=='CAGR') link.value = link.absValue
   if (_value == 'change' && link.deltaSign < 0 ) link.color = "red"
   else if (_value == 'change') link.color = GREEN
   else if (_value == 'CAGR' && link.cagrSign < 0) link.color ="red"
   else if (_value =='CAGR') link.color = GREEN
   else link.color = GREY;
}

const setLinkOpacity = (links) => {
    if (_value == 'change') {
        let vals = getUniqueValues(links,'deltaPct')
        let sortedVals = sortVals(vals)
     
        links.map((link) => {
            sortedVals.map((val,idx) => {
                if (link.deltaPct == val) {link.opacity = idx/sortedVals.length}
            })
        })
    }
    else if (_value == 'CAGR') {
        let vals = getUniqueValues(links,'cagr')
        let sortedVals = sortVals(vals)
     
        links.map((link) => {
            sortedVals.map((val,idx) => {
                if (link.cagr == val) {link.opacity = idx/sortedVals.length}
            })
        })
    }
    else links.map((link) => link.opacity=_linkOpacity)
}

const calcHHI = (_xHighlighted) => {
    let nodes1 = filterKeyVal(_nodeData,'x0',_xHighlighted.x0)
    let vals1 = nodes1.map((node) => {return node.value})
    let total = vals1.reduce((a,b) => a+b)
    let shares = vals1.map((val) => {return Math.pow(((val/total)*100),2)})
    let HHI = shares.reduce((a,b) => a+b)
    return HHI
}

const setHighlightedX = (d) => {
    document.getElementById('HHI-value').innerHTML = calcHHI(d).toFixed(2)
    document.getElementById('HHI-name').innerHTML = d.id[d.id.length-1]
    if (_xHighlighted == 0) {
        _xHighlighted = d
        _xHighlightedName = d.id.slice(0,-1)
        document.getElementById('ratio-name1').innerHTML = _xHighlightedName
        document.getElementById('ratio-name2').innerHTML = ''
        document.getElementById('ratio-value').innerHTML = ''
    }
    else {
        _ratio = _xHighlighted.value/d.value
        _xHighlighted2 = d
        //_xHighlighted = 0
        let formRatio = (_ratio*100).toFixed(2) + '%'
        document.getElementById('ratio-value').innerHTML = formRatio
        document.getElementById('ratio-name2').innerHTML = d.id.slice(0,-1)
    }
    draw()
    if (_xHighlighted !=0 && _xHighlighted2 != 0) {
        _xHighlighted=0
        _xHighlighted2=0
    }
    //console.log(d)
}