
root = exports ? this
root.SourceTUsuarios = "/configuracion/recuperar_usuario"

jQuery ->
  
  $(".wizard").bwizard({nextBtnText: "Siguiente &rarr;", backBtnText: "&larr; Anterior"})

  Actions = new DTActions
    'conf' : '010'
    'idtable': 'table_registrados'
    'EditFunction': (nRow, aData, iDisplayIndex) ->
      $("#usuario").show()
      $("#btnGuardar_Usuario").show()
      $("#btnRegistrar_Usuario").hide()
      menus = getAjaxObject  "/configuracion/recuperar_menu_usuario/"+aData.id
      $("form").reset()
      $('input:checkbox').removeAttr 'checked' 
      $("#id_usuario").val aData.id
      $("#email").val aData.email
      $("#nombre").val aData.var_usuario_nombre
      $("#apellido").val aData.var_usuario_apellido
      $("#documento").val aData.var_usuario_documento
      $(menus).each (index) ->
        $("#"+this.var_menu_nombre).attr "checked", true

  FormatoUsuariosTable = [   { "sWidth": "30%","mDataProp": "email"},
                              { "sWidth": "20%","mDataProp": "var_usuario_nombre"},
                              { "sWidth": "30%","mDataProp": "var_usuario_apellido"}
                              ]

  UsuariosRowCB = (  nRow, aData, iDisplayIndex ) ->
    Actions.RowCBFunction nRow, aData, iDisplayIndex 

  UsuariosTable = createDataTable "table_registrados", root.SourceTUsuarios, FormatoUsuariosTable, null, UsuariosRowCB
      
  SuccessFunctionU = ( data ) ->
    UsuariosTable.fnReloadAjax root.SourceTUsuarios
    ClearFunction()

  ClearFunction = ->
    $("#btnGuardar_Usuario").hide()
    $("#btnRegistrar_Usuario").show()
    $("form").reset()
    $('input:checkbox').removeAttr 'checked' 
    $("#usuario").hide()

  $(".btncancelarform").click (event) ->
    event.preventDefault()
    ClearFunction()
    

  $("#registrar_usuario").click (event) ->
    event.preventDefault()
    $("#usuario").show()

  $("#btnRegistrar_Usuario").click (event) ->
    event.preventDefault()  
    if $("#form_usuario").validationEngine 'validate'
      enviar "/configuracion/guardar_usuario", $("#form_usuario").serialize(), SuccessFunctionU, null
      console.log "validado"

  $("#btnGuardar_Usuario").click (event) ->
    event.preventDefault()
    if $("#form_usuario").validationEngine 'validate'
      enviar "/configuracion/editar_usuario", $("#form_usuario").serialize(), SuccessFunctionU, null
      console.log "validado"

  $("#form_usuario").validationEngine 'attach',{autoHidePrompt:true,autoHideDelay:3000}
