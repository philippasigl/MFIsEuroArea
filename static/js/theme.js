const EXTENDED_DISCRETE_COLOR_RANGE = [
    '#003299',
    '#2E93E5',
    '#328DD2',
    '#8FD3F2',
    '#5CA3DB',
    '#8CBDE5',
    '#2A5668',
    '#12859C',
    '#2D2D2D',
    '#5D5F5F',
    '#BBBBBB',
    '#FFF315',
    '#191919',
    '#DADADA',
    '#19CDD7',
    '#DDB27C',
    '#88572C',
    '#FF991F',
    '#F15C17',
    '#223F9A',
    '#DA70BF',
    '#125C77',
    '#4DC19C',
    '#776E57',
    '#12939A',
    '#17B8BE',
    '#F6D18A',
    '#B7885E',
    '#FFCB99',
    '#F89570',
    '#829AE3',
    '#E79FD5',
    '#1E96BE',
    '#89DAC1',
    '#B3AD9E'
  ];

 const EXTENDED_DISCRETE_COLOR_RANGE2 = [
    '#19CDD7',
    '#DDB27C',
    '#88572C',
    '#FF991F',
    '#F15C17',
    '#223F9A',
    '#DA70BF',
    '#125C77',
    '#4DC19C',
    '#776E57',
    '#12939A',
    '#17B8BE',
    '#F6D18A',
    '#B7885E',
    '#FFCB99',
    '#F89570',
    '#829AE3',
    '#E79FD5',
    '#1E96BE',
    '#89DAC1',
    '#B3AD9E'
  ];

  const SHORT_COLORS = ['#000077', '#008877','#0055ee', '#00ddcc', '#00cc77']
  const PAST_COLORS = ['#0066cc','#00C78C','#8cb3d9','#4d94ff','#80b3ff','#99ffff','#8cd9b3','#66ffd9','#80ffcc','#cccc99','#ffccb3','#ffaa80']
  const BOTERO_COLORS = ['#99B6BD', '#B3A86A', '#ECC9A0', '#D4613E', '#BB9568']
  const GREEN = '#008B45'
  const GREY = '#505050'
  const DARK_BLUE = '#000080'
  const getRGBColors = (colors) => {
      return colors.map((col) => {return d3.rgb(col)} )
  }
  const getDarker = (colors) => {
    let colorsRGB = getRGBColors(colors)
    return colorsRGB.concat(colorsRGB.map((col) => {return newCol = col.darker(3)}))
  }  
  const getBrighter = (colors) => {
    let colorsRGB = getRGBColors(colors)
    let newCol=colorsRGB.map((col) => {return col = col.brighter(2)})
    return colorsRGB
  }  
  const ext_botero = getBrighter(BOTERO_COLORS)
  const EXT_SHORT_COLORS=getBrighter(SHORT_COLORS)
  const D3_COLORS = d3.schemeSet3
  const D3_PASTEL = d3.schemePastel1
  const test = d3.rgb(BOTERO_COLORS[0])
  const BREWER_BLUE= ["#edf8b1","#c7e9b4","#7fcdbb","#41b6c4","#1d91c0","#225ea8","#253494","#081d58"]
  const COLORS=PAST_COLORS
