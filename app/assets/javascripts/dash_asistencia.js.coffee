root = exports ? this

jQuery ->
  
  $("#form_asistencia").change (event) ->
    if $("#mes").is ':checked'
      $('#mes_lista').prop 'disabled',false
    else
      $('#mes_lista').prop 'disabled','disabled'
      $('#mes_lista').val 0
      $("#semanadiv").hide()

    if $("#mes_lista").val() == '0'
      $("#semanadiv").hide()
    else
      $("#semanadiv").show()

    if $("#semana").is ':checked'
      $('#semana_lista').prop 'disabled',false
    else
      $('#semana_lista').prop 'disabled','disabled'

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
      if data.length == 2
        $("#dash_general_lineas").highcharts data[0]
        $("#dash_general_pie").highcharts data[1]

  $("#btnGenerar_asistencia").click (event) ->
    event.preventDefault()
    if $("#form_asistencia").validationEngine 'validate'
      PrepararDatos()
      enviar "/recuperar_data_asistencia", root.DatosEnviar, SuccessFunction, null

  $("#form_asistencia").validationEngine 'attach',{autoHidePrompt:true,autoHideDelay:3000}