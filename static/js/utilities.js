const sortByKey = (arrOfDict,key) => {
    sortedArray = arrOfDict.sort((a,b)=> {return a[key]-b[key]})
    return sortedArray
}

const getUniqueValues = (arrayOfDict,key) => {
    let uniqueValues=[]
    arrayOfDict.map((val) => {
        if (uniqueValues.indexOf(val[key])==-1) {
            uniqueValues.push(val[key])
        }
    })
    return uniqueValues
}

const sortVals = (vals) => { return vals.sort((a,b) => {return a-b})}

const revDict = (input) => {
    let rev = {}
    for (key in input) rev[input[key]] = key
    return rev
}

const intToFloat = (integ) => {
    let intStr = integ.toFixed(2)
    return parseFloat(intStr)
}

const filterKeyVal = (arrDict,key,val) => {
    return arrDict.filter((item) => {return item[key]==val})
}