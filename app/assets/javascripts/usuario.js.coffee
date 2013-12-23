
root = exports ? this
root.SourceTUsuarios = "/configuracion/recuperar_usuario"

jQuery ->
  
  $(".wizard").bwizard({nextBtnText: "Siguiente &rarr;", backBtnText: "&larr; Anterior"})

  FormatoUsuariosTable = [   { "sWidth": "30%","mDataProp": "email"},
                              { "sWidth": "20%","mDataProp": "var_usuario_nombre"},
                              { "sWidth": "30%","mDataProp": "var_usuario_apellido"},
                              { "sWidth": "20%","mDataProp": "acciones"}
                              ]

  UsuariosRowCB = (  nRow, aData, iDisplayIndex ) ->
    index = $(UsuariosTable.fnGetData()).getIndexObj aData, 'id'
    acciones = getActionButtons "000"
    UsuariosTable.fnUpdate( acciones, index, 3 ); 

  UsuariosTable = createDataTable "table_registrados", root.SourceTUsuarios, FormatoUsuariosTable, null, UsuariosRowCB

# Proceso para enviar metodo Post

# 1. Preparar Datos

  # Datos para enviar en formato JSON
  PrepararDatosU = ->
    root.DatosEnviar = $("#form_usuario").serialize()
      
  SuccessFunctionU = ( data ) ->
    UsuariosTable.fnReloadAjax root.SourceTUsuarios
    $("#form_usuario").reset()
    console.log(data)

  $(".btncancelarform").click (event) ->
    event.preventDefault()
    $("form").reset()
    $("#usuario").hide()

  $("#registrar_usuario").click (event) ->
    event.preventDefault()
    $("#usuario").show()

  $("#btnGuardar_Usuario").click (event) ->
    event.preventDefault()  
    if $("#form_usuario").validationEngine 'validate'
      PrepararDatosU()
      enviar "/configuracion/guardar_usuario", root.DatosEnviar, SuccessFunctionU, null

  $("#form_usuario").validationEngine 'attach',{autoHidePrompt:true,autoHideDelay:3000}
