root = exports ? this


 
    

jQuery ->
  

  PrepararDatos = ->
    root.DatosEnviar =
      "formulario" : $("#form_asistencia").serializeObject()

  SuccessFunction = ( data ) ->
    if data.length == 6
      $("#dash_general_lineas").highcharts data[0]    
      $("#dash_general_pie").highcharts data[1]
      $("#dash_mujeres_joven").highcharts data[2]
      $("#dash_hombres_joven").highcharts data[3]
      $("#dash_mujeres_adulto").highcharts data[4]
      $("#dash_hombres_adulto").highcharts data[5]
    else 
      console.log data
      $("#dash_general_lineas").highcharts data

  $("#btnGenerar_asistencia").click (event) ->
    event.preventDefault()
    PrepararDatos()
    enviar "recuperar_data_asistencia", root.DatosEnviar, SuccessFunction, null
    
