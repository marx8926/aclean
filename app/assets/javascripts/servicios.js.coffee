root = exports ? this
root.SourceTServicio = "/configuracion/recuperar_servicio"
root.SelectToDrop = null
jQuery ->
  count = 0;
  $("#servicio").hide()

  $("#btnGuardarServicio").hide()

  HorarioTable = $('#horario').dataTable
    "aoColumns": [
      {"mDataProp": "var_turno_dia_des"},
      {"mDataProp": "var_turno_horainicio"},
      {"mDataProp": "var_turno_horafin"},
      {"mDataProp": "btn_elim"}]
    "bPaginate": false
    "sDom": "<r>t<'row-fluid'>"
    "fnCreatedRow": (  nRow, aData, iDisplayIndex ) ->
      $(nRow).find('.delete-row').click (event) ->
        event.preventDefault()
        index = $(HorarioTable.fnGetData()).getIndexObj aData, 'id'
        HorarioTable.fnDeleteRow index

  FormatoServiciosTable = [   { "sWidth": "30%","mDataProp": "var_servicio_nombre"},
                              { "sWidth": "20%","mDataProp": "int_servicio_tipo_desc"},
                              { "sWidth": "30%","mDataProp": "turnoshow"},
                              { "sWidth": "20%","mDataProp": "var_servicio_acciones"}
                              ]

  ServiciosRowCB = (  nRow, aData, iDisplayIndex ) ->
    index = $(ServiciosTable.fnGetData()).getIndexObj aData, 'int_servicio_id'
    acciones = getActionButtons "111"
    ServiciosTable.fnUpdate( acciones, index, 3 ); 
    $(nRow).find('.delete-row').click (event) ->
      event.preventDefault()
      root.SelectToDrop = aData.int_servicio_id
      DisplayBlockUISingle "dangermodal"
    $(nRow).find('.edit_row').click (event) ->
      event.preventDefault()
      $("#nombre").val aData.var_servicio_nombre
      $("#tipo").val aData.int_servicio_tipo
      $("#idservicio").val(aData.int_servicio_id)
      HorarioTable.fnClearTable()
      $(aData.turnos).each (index) ->
        dia_desc = getDiaSemana this.int_turno_dia
        horario =
          "var_turno_dia_des": dia_desc
          "int_turno_dia": this.int_turno_dia
          "var_turno_horainicio" : this.var_turno_horainicio
          "btn_elim": getActionButtons "001"
          "id": this.int_turno_id
        HorarioTable.fnAddData horario
      $("#servicio").show()
      $("#nombre").focus()
      $("#btnGuardarServicio").show()
      $("#btnRegistrarServicio").hide()
      $("#registrar").text("Guardar Cambios")

  ServiciosTable = createDataTable "tablaservicios", root.SourceTServicio, FormatoServiciosTable, null, ServiciosRowCB
      
  $('#addhorario').click (event)->
    event.preventDefault()
    dia_desc = getDiaSemana $("#dia").val()
    horario = 
      "id":count
      "var_turno_dia_des": dia_desc
      "int_turno_dia":$("#dia").val()
      "var_turno_horainicio" :$("#hora").val()
      "var_turno_horafin" :$("#hora_fin").val()
      "btn_elim":getActionButtons "001"
    HorarioTable.fnAddData horario
    count++

  $("#btnSiEliminar").click (event) ->
    event.preventDefault()
    DisplayBlockUI "loader"
    enviar "/configuracion/drop_servicio", {"idservicio":root.SelectToDrop}, SuccessFunctionDropServicio, null

  $("#btnSiGuardar").click (event) ->
    event.preventDefault()    
    #Llamada a preparar Datps
    PrepararDatos()
    DisplayBlockUI "loader"
    enviar "/configuracion/editar_servicio", root.DatosEnviar, SuccessFunctionServicio, null

  $(".btnNo").click (event) ->
    event.preventDefault()
    $.unblockUI()

  $("#cancelarGuardar").click (event) ->
    event.preventDefault()
    $("#formServicio").reset()
    HorarioTable.fnClearTable()
    $("#servicio").hide()
    $("#btnGuardarServicio").hide()
    $("#btnRegistrarServicio").show()
    $("#registrar").text("Agregar Servicio")


  $('#registrar').click (event) ->
    event.preventDefault()
    $("#servicio").show()

# Proceso para enviar metodo Post

# 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatos= ->
    root.DatosEnviar =
      "formulario" : $("#formServicio").serializeObject()
      "otherdata" : HorarioTable.fnGetData()

  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunctionServicio = ( data ) ->
    MessageSucces()
    #recargar datos de tabla Servicios
    ServiciosTable.fnReloadAjax root.SourceTServicio
    #resetear formulario
    $("#formServicio").reset()
    #reniciar tabla
    HorarioTable.fnClearTable()
    #mostrar datos de respuesta
    $("#btnGuardarServicio").hide()
    $("#btnRegistrarServicio").show()
    $("#registrar").text("Agregar Servicio")
    $("#servicio").hide()

  $("#btnGuardarServicio").click (event) ->
    event.preventDefault()
    if HorarioTable.fnGetData.lenght > 0
      DisplayBlockUISingle "confirmmodal"
    else
      alert "Falta agregar Horario"

# 2. Enviar Datos
  $("#btnRegistrarServicio").click (event) ->
    event.preventDefault()
    #Llamada a preparar Datps
    if HorarioTable.fnGetData.lenght > 0
      PrepararDatos()
      #Llamada a envio Post
      DisplayBlockUI "loader"
      enviar "/configuracion/guardar_servicio", root.DatosEnviar, SuccessFunctionServicio, null
    else
      alert "Falta agregar Horario"

# Fin Proceso enviar Formulario

  #Refrescar tabla al elimnar servicio
  SuccessFunctionDropServicio = (data) ->
    MessageSucces()
    ServiciosTable.fnReloadAjax root.SourceTServicio
  
  MessageSucces = ->
    setTimeout (->
      $.unblockUI onUnblock: ->
        $.growlUI "Operacion Exitosa"

    ), 1000

  $("#formServicio").validationEngine 'attach',{autoHidePrompt:true,autoHideDelay:3000}
