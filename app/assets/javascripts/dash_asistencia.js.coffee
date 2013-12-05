$("#dash_general_lineas").highcharts
  title:
    text: "Asistencia 2013 por mes"
    x: -20

  subtitle:
    text: "Iglesia"
    x: -20

  xAxis:
    categories: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"]

  yAxis:
    title:
      text: "Asistencia"

    plotLines: [
      value: 0
      width: 1
      color: "#808080"
    ]

  tooltip:
    valueSuffix: ""

  legend:
    layout: "vertical"
    align: "right"
    verticalAlign: "middle"
    borderWidth: 0

  series: [
    name: "Hombres A."
    data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
  ,
    name: "Mujeres A."
    data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
  ,
    name: "Hombres J."
    data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
  ,
    name: "Mujeres J."
    data: [13.9, 14.2, 15.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
  ]


$("#dash_general_pie").highcharts
  chart:
    plotBackgroundColor: null
    plotBorderWidth: null
    plotShadow: false

  title:
    text: "Asistencia 2013"

  tooltip:
    pointFormat: "{series.name}: <b>{point.percentage:.1f}%</b>"

  plotOptions:
    pie:
      allowPointSelect: true
      cursor: "pointer"
      dataLabels:
        enabled: true
        color: "#000000"
        connectorColor: "#000000"
        format: "<b>{point.name}</b>: {point.percentage:.1f} %"

  series: [
    type: "pie"
    name: "Browser share"
    data: [["Mujeres A.", 45.0], ["Hombres A.", 26.8], ["Mujeres J.", 16.2], ["Hombres J.", 10.7]]
  ]


$("#dash_detalle_mujeres").highcharts
  chart:
    type: "line"

  title:
    text: "Asistencia Mujeres"

  subtitle:
    text: "Iglesia"

  xAxis:
    categories: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"]

  yAxis:
    title:
      text: "Asistencia #"

  tooltip:
    enabled: false
    formatter: ->
      "<b>" + @series.name + "</b><br/>" + @x + ": " + @y + "°C"

  plotOptions:
    line:
      dataLabels:
        enabled: true

      enableMouseTracking: false

  series: [
    name: "Adultas"
    data: [70, 69, 95, 145, 184, 215, 252, 265, 233, 183, 139, 96]
  ,
    name: "Jovenes"
    data: [39, 42, 57, 85, 119, 152, 170, 166, 142, 103, 66, 48]
  ]

$("#dash_detalle_hombres").highcharts
  chart:
    type: "line"

  title:
    text: "Asistencia Hombres"

  subtitle:
    text: "Iglesia"

  xAxis:
    categories: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"]

  yAxis:
    title:
      text: "Asistencia #"

  tooltip:
    enabled: false
    formatter: ->
      "<b>" + @series.name + "</b><br/>" + @x + ": " + @y + "#"

  plotOptions:
    line:
      dataLabels:
        enabled: true

      enableMouseTracking: false

  series: [
    name: "Adultos"
    data: [80, 69, 95, 145, 154, 115, 152, 165, 133, 183, 139, 96]
  ,
    name: "Jovenes"
    data: [49, 42, 57, 85, 119, 152, 170, 166, 142, 103, 66, 48]
  ]
