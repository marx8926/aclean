root = exports ? this
root.SourceTServicio = "/configuracion/recuperar_servicio"
jQuery ->
  count = 0;

  HorarioTable = $('#horario').dataTable
    "aoColumns": [{"mDataProp": "dia"},{"mDataProp": "hora"},{"mDataProp": "btn_elim"}]
    "bPaginate": false
    "sDom": "<r>t<'row-fluid'>"
    "fnCreatedRow": (  nRow, aData, iDisplayIndex ) ->
      $(nRow).find('.delete-row').click (event) ->
        event.preventDefault()
        index = $(HorarioTable.fnGetData()).getIndexObj aData, 'id'
        HorarioTable.fnDeleteRow index

  FormatoServiciosTable = [   { "sWidth": "30%","mDataProp": "var_servicio_nombre"},
                              { "sWidth": "20%","mDataProp": "int_servicio_tipo_desc"},
                              { "sWidth": "30%","mDataProp": "turnos"},
                              { "sWidth": "20%","mDataProp": "var_servicio_acciones"}
                              ]

  ServiciosRowCB = (  nRow, aData, iDisplayIndex ) ->
      index = $(ServiciosTable.fnGetData()).getIndexObj aData, 'int_servicio_id'
      acciones = getActionButtons "111"
      ServiciosTable.fnUpdate( acciones, index, 3 ); 
      $(nRow).find('.delete-row').click (event) ->
        event.preventDefault()
        r=confirm("Desea eliminar el servicio")
        if(r==true)
          enviar "/configuracion/drop_servicio", {"idservicio":aData.int_servicio_id}, SuccessFunctionDropServicio, null

  ServiciosTable = createDataTable "tablaservicios", root.SourceTServicio, FormatoServiciosTable, null, ServiciosRowCB
      
  $('#addhorario').click (event)->
    event.preventDefault()
    horario = { "dia":$("#dia").val(), "hora" :$("#hora").val(), "btn_elim":getActionButtons "001", "id":count}
    HorarioTable.fnAddData horario
    count++

  $("#servicio").hide()

  $('#registrar').click (event) ->
    event.preventDefault()
    $("#servicio").toggle()

# Proceso para enviar metodo Post

# 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatos = ->
    root.DatosEnviar =
      "formulario" : $("#formServicio").serializeObject()
      "otherdata" : HorarioTable.fnGetData()

  # Funcion de respuesta CORRECTA
  # Los datos de respuesta se reciben en data
  SuccessFunctionServicio = ( data ) ->
    #recargar datos de tabla Servicios
    ServiciosTable.fnReloadAjax root.SourceTServicio
    #resetear formulario
    $("#formServicio").reset()
    #reniciar tabla
    HorarioTable.fnClearTable()
    #mostrar datos de respuesta
    console.log(data)

# 2. Enviar Datos
  $("#btnGuardar_Servicio").click (event) ->
    event.preventDefault()
    #Llamada a preparar Datps
    PrepararDatos()
    #Llamada a envio Post
    enviar "/configuracion/guardar_servicio", root.DatosEnviar, SuccessFunctionServicio, null

# Fin Proceso enviar Formulario

  #Refrescar tabla al elimnar servicio
  SuccessFunctionDropServicio = (data) ->
    ServiciosTable.fnReloadAjax root.SourceTServicio    
    console.log(data)

    #act on result.
    false # prevents normal behaviour