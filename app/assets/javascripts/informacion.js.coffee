# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



root = exports ? this


jQuery ->

  datos_miembros = getAjaxObject "data_miembro"
  datos_visita = getAjaxObject "data_visitante"
  datos_pie = getAjaxObject "data_pie"
  $ ->
  	$("#dash_miembro").highcharts datos_miembros
  	$("#dash_visita").highcharts datos_visita
  	$("#dash_pie").highcharts datos_pie

  PrepararDatos = ->
    root.DatosEnviar =
      "formulario" : $("#form_diezmo").serializeObject()

    console.log "preparar"

  SuccessFunction = ( data ) ->
    console.log data
    

  $("#btnGenerar_diezmo").click (event) ->
    event.preventDefault()
    
    PrepararDatos()
    enviar "/recuperar_data_diezmo", root.DatosEnviar, SuccessFunction, null

datos_diezmo = getAjaxObject "recuperar_data_diezmo"

$("#dash_diezmo").highcharts datos_diezmo