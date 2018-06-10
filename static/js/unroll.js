var _level = 0

const subsetLinks = (links,level) => {
    let shallowCopyData = JSON.parse(JSON.stringify(links))

    let newLinks= shallowCopyData.filter((link) => {
        return link.source.slice(-1) == _level
    })
    return newLinks
}

const setNewLinks = (links) => {
    let newColorMap = newLinkColors(links)
    //checks whether fewer nodes to the left or right handside and hence determines edge_type
    let direct = checkDirectionalityLevel(sankey_values,_level)
    let newLinks = links.map((link) => {
        let newLink={}    
        let newVals = setNewValues(link)
        newLink.target_level = newVals[1]
        newLink.source_level= newVals[2]
        newLink.source = link.time + newLink.source_level
        newLink.target = newVals[0] + newLink.target_level
        newLink.value = link.absValue
        newLink.color = setNewColor(link,newColorMap,direct)
        newLink.uniqueID = link.uniqueID
        direct == 'leftToRight' ? newLink.edge_type = link.source : newLink.edge_type = link.target
        newLink.time = link.target
        return newLink
    })
    return newLinks
}

const setNewValues = (link) => {
    let dateStrings = Object.values(dates)
    let target = 0
    let target_level = 0
    let source_level = 0
    dateStrings.map((d,idx) => {
        if (link.time == d) {
            idx<dateStrings.length-1 ? target = dateStrings[idx+1] : target = "end"
            target_level = idx+1
            source_level = idx
        }
    })
    return [target,target_level,source_level]
}
const setNewNodes = () => {
    let names = Object.values(dates)
    let newNodes = names.map((name,idx) => {
        let node={}
        node.id = name + idx
        node.name = node.id
        node.color = colors[0]
        return node
    })
    newNodes.push({id: "end"+names.length, name: "end", color: colors[0] })
    return newNodes
}

const newLinkColors = (links) => {
    let categories = getUniqueValues(links,'source').concat(getUniqueValues(links,'target'))
    
    let colors = getColors(categories,COLORS)
    colorMap={}
    categories.map((cat,idx) => { colorMap[cat]=colors[idx]} )
    return colorMap
}  

const setNewColor = (oldLink,colorMap,direct) => {
    return direct == 'leftToRight' ? colorMap[oldLink.source] : colorMap[oldLink.target]
}

const unrollData = () => {
    let selectedLinks = subsetLinks(sankey_values,_level)
    let newLinks = setNewLinks(selectedLinks)
    let newNodes = setNewNodes()
    let data = {nodes: newNodes, links: newLinks}
    return data
}

const unrollOptions = () => {
    _linkOpacity = 1
    _nodeOpacity = 0.5
    _nodeWidth = 0.1
}

const switch_mode = () => {
    _mode = document.getElementById("mode").value
    disableOptions()
    draw()
}

const switch_Level = () => {
    _level = document.getElementById("level").value
    draw()
}

const checkDirectionalityLevel =(links,_level) => {
    let levelLinks = links.filter((link) => {return link.source_level==_level})
    let uniqueSourceNodes = getUniqueValues(levelLinks,'source')
    let uniqueTargetNodes = getUniqueValues(levelLinks,'target')
    return uniqueSourceNodes.length > uniqueTargetNodes.length ? 'leftToRight' : 'rightToLeft'
    //console.log(targetLevel)
    //let sourceLinks = links.filter((link) => {return link.source_level==targetLevel})
    //let targetLinks = links.filter((link) => {return link.target_level==targetLevel})
    //console.log("source",sourceLinks)
    //console.log("target",targetLinks)
    //return targetLinks.length > sourceLinks.length ? 'leftToRight' : 'rightToLeft'
}