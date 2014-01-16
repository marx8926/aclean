
root = exports ? this
root.SourceTUsuarios = "/configuracion/recuperar_usuario"

jQuery ->
  
  $(".wizard").bwizard({nextBtnText: "Siguiente &rarr;", backBtnText: "&larr; Anterior"})

  Actions = new DTActions
    'conf' : '101',
    'idtable': 'table_registrados',
    'ViewFunction': (nRow, aData, iDisplayIndex) ->      
      console.log aData

    'EditFunction': (nRow, aData, iDisplayIndex) ->
      console.log aData

    'DropFunction': (nRow, aData, iDisplayIndex) ->      
      console.log aData

  FormatoUsuariosTable = [   { "sWidth": "30%","mDataProp": "email"},
                              { "sWidth": "20%","mDataProp": "var_usuario_nombre"},
                              { "sWidth": "30%","mDataProp": "var_usuario_apellido"}
                              ]

  UsuariosRowCB = (  nRow, aData, iDisplayIndex ) ->
    Actions.RowCBFunction nRow, aData, iDisplayIndex 

  UsuariosTable = createDataTable "table_registrados", root.SourceTUsuarios, FormatoUsuariosTable, null, UsuariosRowCB

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
