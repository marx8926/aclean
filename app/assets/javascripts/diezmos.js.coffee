# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this

jQuery ->
	
  $('#diezmo_div').hide()

  $('#registrar_diezmo').click ->
    $("#diezmo_div").toggle()
    

$(document).ready ->
  $(".data-table").dataTable sPaginationType: "full_numbers"


personas = getAjaxObject("/persona_servicio_complete")

$ ->
  $("#persona").autocomplete(
    source: personas
    select: (event, ui) ->
      $("#persona_hidden").val ui.item.int_persona_id
      $("#persona").val ui.item.label
      false
  )

#guardar diezmo

# Proceso para enviar metodo Post

# 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatos = ->
    root.DatosEnviar = $("#form_diezmo").serialize()
      
  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunction = ( data ) ->
    #recargar datos de tabla Servicios
    #ServiciosTable.fnReloadAjax "/configuracion/recuperar_servicio"
    #resetear formulario
    #$("#form_iglesia").reset()
    #reniciar tabla
    #HorarioTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

# 2. Enviar Datos
  $("#btnGuardar_Diezmo").click (e) ->
    #Llamada a preparar Datps
    PrepararDatos()
    #Llamada a envio Post
    enviar "/diezmos_guardar", root.DatosEnviar, SuccessFunction, null

# Fin Proceso enviar Formulario
      
    #act on result.
    false # prevents normal behaviour