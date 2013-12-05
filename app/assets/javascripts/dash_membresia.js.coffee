datos_miembros = getAjaxObject "data_miembro"
datos_visita = getAjaxObject "data_visitante"
datos_pie = getAjaxObject "data_pie"

$("#dash_miembro_lineas").highcharts datos_miembros
$("#dash_visita_lineas").highcharts datos_visita
$("#dash_pie_membresia").highcharts datos_pie