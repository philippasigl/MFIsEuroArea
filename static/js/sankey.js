
//check whether valid data
const checkValidData =() => {
    if (sankey_values === -1) return
}
checkValidData()
console.log("hello")
//get unique IDs which remain constant for all time periods
const setUniqueIDs = () => {
    let uniqueProps = []
    nextId=0
    sankey_values.map((val) => {
        props = val.source + val.target + val.edge_type
        if (uniqueProps.indexOf(props)==-1) { 
            val.uniqueID = nextId
            nextId=nextId+1
        }
        else {
            val.uniqueID = uniqueProps.indexOf(props)
        }
        uniqueProps.push(props)
    })
}
setUniqueIDs()

//specifies the id for a node row
const setKeys = (sankey_values_row,key,key_level) => {
    //if source_level= -1 (unspecified), set it to 0
    key_level == 'source_level' && sankey_values_row[key_level] == -1 ? sankey_values_row[key_level] = 0 : sankey_values_row[key_level]
    //if target_level = -1 (unspecified, set it to 1)
    key_level == 'target_level' && sankey_values_row[key_level] == -1 ? sankey_values_row[key_level] = 1 : sankey_values_row[key_level]
    //id is key+key_level
    let val = sankey_values_row[key].concat(sankey_values_row[key_level])
    //also change id in sankey_values
    sankey_values_row[key] = val
    return val
}

//defines a node row
const defineNode = (sankey_values_row,key,key_level) => {
    row={};
    row.name = sankey_values_row[key]
    row.time = sankey_values_row.time
    row.id = setKeys(sankey_values_row,key,key_level)
    return row
}

const setNodes = () => {
    let nodes=[]
    sankey_values.map((val) => {
        let sourceRow = defineNode(val,'source','source_level')
        nodes.push(sourceRow)
    }) 
    sankey_values.map((val) => {
        let targetRow = defineNode(val,'target','target_level')
        nodes.push(targetRow)
    })  
    
    return nodes
}
let duplicateNodes = setNodes()

const uniqueNodes = (nodes) => {
    filteredNodes = []
    nodes.filter((item) => {
        let i = filteredNodes.findIndex(x => x.id == item.id && x.time == item.time)
        if(i <= -1) filteredNodes.push({id: item.id, name: item.name, time: item.time})
    })
    return filteredNodes
}
let nodes = uniqueNodes(duplicateNodes)

//assign colours to nodes and edges; use consistent colours for all periods
//find nodes across time periods
const uniqueNodesAllPeriods = (nodes) => {
    let uniqueNodes = []
    nodes.filter((item) => {
        var i = uniqueNodes.findIndex(x => x.id == item.id)
        if(i <= -1)
            uniqueNodes.push({id: item.id})
    })

    return uniqueNodes
}
let _uniqueNodesAllPeriods = uniqueNodesAllPeriods(nodes)

//get colors and ensure enough colours present
const getColors = (nodes,colors) => {
    if (colors.length<nodes.length) {
        extendedColors=colors
        extend=Math.round((nodes.length/colors.length)+1)
        for (i=0;i<extend-1;i++) {
            extendedColors=extendedColors.concat(colors)
        }
        colors=extendedColors
    }
    return colors
}
let colors = getColors(_uniqueNodesAllPeriods,COLORS)

//map colors to unique nodes
const addColor = (node,idx) => {
    node.color = colors[idx]
}
_uniqueNodesAllPeriods.forEach(addColor)

//assign colors to node array
const assignColorNodes = (node,uniqueNodes) => {
    var colIndex = uniqueNodes.findIndex( uniqueNode => node.id == uniqueNode.id)
    node.color = uniqueNodes[colIndex].color
    node.opacity = uniqueNodes[colIndex].opacity
}
nodes.map((node) => assignColorNodes(node,_uniqueNodesAllPeriods))

//assign colors to edges
const getEdgeColors = () => {
    let edge_types = getUniqueValues(sankey_values,'edge_type')
    edge_type_cols={}
    edge_types.map((ed,idx) => edge_type_cols[ed]=colors[idx])
    return edge_type_cols
}

const assignColorEdges = (edge,edge_types_cols) => {
    edge.color = edge_types_cols[edge.edge_type]    
}
let edge_colors = getEdgeColors()
sankey_values.map((val) => (assignColorEdges(val,edge_colors)))

const addDeltaStartingPeriod = () => {
    let dateAr = Object.values(dates)

    let refSet={}
    sankey_values.map((val) => { 
        if (val.time == dateAr[0]) {
            refSet[val.source+val.target+val.edge_type]=val.absValue
    } })
    sankey_values.map((val) => { 
        
        if (typeof refSet[val.source+val.target+val.edge_type] != 'undefined') {
            val.delta = val.absValue-refSet[val.source+val.target+val.edge_type]
            if (val.delta < 0) {val.deltaSign = -1; val.delta=val.delta*(-1)} 
            else val.deltaSign=1
            //to prevent chart from crashing
            if (val.delta == 0) val.delta = 0.00000000001
            val.deltaPct = val.absValue/refSet[val.source+val.target+val.edge_type]*100
            let CAGR = calcAvgCAGR(val)
            val.cagr = CAGR
            if (val.cagr>0) val.cagrSign=1
            else if (val.cagr<0) {val.cagr=val.cagr*(-1); val.cagrSign=-1}
            else val.cagr = 0.00000000001
            //console.log("st",CAGR)
            //console.log("end",val.time)
        }
    })
}

const calcAvgCAGR = (link) => {
    let dateRev = revDict(dates)
    let startYear = getFirstFullYearQuartDates()
    let endYear = dateRev[link.time]
    let startPoint = parseFloat(startYear)+parseFloat((endYear-startYear)%12)
    let startVal
    sankey_values.map((val) => {
        if (val.time == dates[startPoint] && 
            val.source==link.source && 
            val.target==link.target &&
            val.edge_type==link.edge_type) {
            startVal=val.absValue}
        })
    let endVal=link.absValue
    let CAGR = (Math.pow((endVal/startVal),(1/(endYear/12-startPoint/12)))-1)*100
    return CAGR
}

const getFirstFullYearQuartDates = () => {
    for (let key in dates) if (key%12 == 3) return key
}
addDeltaStartingPeriod()


//split the nodes into arrays for each time period (since sankey connects to nodes by their indices)
/*
filteredNodesByTime=[];
for (i=0;i<dates.length;i++) {
    filteredNodesByTime.push([])
    for (j=0;j<filteredNodes.length;j++) {
        if (filteredNodes[j].time == dates[i]) {
            filteredNodesByTime[i].push(filteredNodes[j])
        }
    }
}
*/

//replace node names with idx in values and create data array
/*
d=[]
for (i=0;i<sankey_values.length;i++) {
    idx = dates.findIndex(x => x == sankey_values[i].time)
    var source = filteredNodesByTime[idx].findIndex(x => x.id == sankey_values[i].source )
    var target = filteredNodesByTime[idx].findIndex(x => x.id == sankey_values[i].target )
    row={};
    row.source = sankey_values[i].source;
    row.target = sankey_values[i].target;
    row.uniqueID = sankey_values[i].uniqueID
    row.source_level=sankey_values[i].source_level
    row.value = sankey_values[i].value;
    row.edge_type = sankey_values[i].edge_type;

    //if there is a time dimension, add the former
    if (typeof sankey_values[i].time !== 'undefined') {
        row.time = sankey_values[i].time;
        //flag that this is a multiPeriod sankey
        multiPeriodSankey=true;
    }
    d.push(row);
}
*/