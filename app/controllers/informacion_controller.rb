require "date"
require "json"

class InformacionController < ApplicationController

	before_filter :authenticate_user!

	def index


	end

	def chart_miembro

		fecha = DateTime.now()

		todo = Chart.where("int_chart_anio" => fecha.year )

		datax = []

		if todo.nil? == false
	    	todo.each{ |x|
	    		datax.push x[:int_chart_miembro]
	    	}
	    end

		
    
    	result = {
    		title: { text: "Membresia 2013" , x: -20},
    		subtitle: { text: "CLM", x: -20 },
            xAxis: {
                categories: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                    'Jul', 'Ago', 'Set', 'Oct', 'Nov', 'Dic']
            },
            yAxis: {
                title: {
                    text: 'Miembros'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: '#'
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            series: [{
                name: 'Iglesia',
                data: datax
            }]
    	}
    	#result[:title] = { :text => "Membresia 2013" , :x => -20}


        render :json => result, :status => :ok
	    
	end

	

	def chart_visitante

        fecha = DateTime.now()

        todo = Chart.where("int_chart_anio" => fecha.year )

        datax = []

        if todo.nil? == false
            todo.each{ |x|
                datax.push x[:int_chart_visita]
            }
        end

        
    
        result = {
            title: { text: "Visitas 2013" , x: -20},
            subtitle: { text: "CLM", x: -20 },
            xAxis: {
                categories: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                    'Jul', 'Ago', 'Set', 'Oct', 'Nov', 'Dic']
            },
            yAxis: {
                title: {
                    text: 'Visitas'
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: '#'
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            series: [{
                name: 'Iglesia',
                data: datax
            }]
        }
        #result[:title] = { :text => "Membresia 2013" , :x => -20}


        render :json => result, :status => :ok
	end

	def pie_chart_init

        visita = Chart.sum(:int_chart_visita, :conditions => [ "int_chart_anio =?",2013])
        miembro = Chart.sum(:int_chart_miembro, :conditions => [ "int_chart_anio =?",2013])

        result = {

            chart: {
                plotBackgroundColor: nil,
                plotBorderWidth: nil,
                plotShadow: false
            },
            title: {
                text: 'Nuevos Miembros vs Nuevas Visitas'
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %'
                    }   
                }
            },
            series: [{
                type: 'pie',
                name: 'Miembros',
                data: [
                    ['Miembro',  miembro],
                    ['Visita',   visita]                   
                ]   
            }]
        }

        render :json => result, :status => :ok
    end


    def diezmo

    end

    def generar_json_column(titulo, subtitulo, ejey, nombre_serie, categorias, result_todo)

                 
        result = {
            chart: {
                type: 'column'
            },
            title: {
                text: titulo
            },
            subtitle:{
                text: subtitulo
            },
            xAxis: {
                categories: categorias
            },
            yAxis: {
                min: 0,
                title: {
                    text: ejey
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f} mm</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0
                }
            },
            series: [{
                name: nombre_serie,
                data: result_todo
                }]


        }
        return result
    end

    def recuperar_data_diezmo

        mes = true
        semana = false
        num_mes = 0
        num_semana = 1
        anio = 2013

        meses = [ "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"]

        categorias = nil

        result_todo = []

        if mes == true and semana == true



        elsif mes == true and semana == false

            if num_mes == 0
                # para todos los meses
                lista = (0 .. 11 ).to_a

                lista.each{ |i|

                    fecha = DateTime.new(anio, i + 1)
                    ini = fecha.beginning_of_month
                    fin = fecha.end_of_month

                    result_todo.push Diezmo.where(dat_diezmo_fecharegistro:( ini .. fin)).sum(:dec_diezmo_monto).to_f

                }
                categorias = meses

            else
                #para un mes en especifico
                fecha = DateTime.new(anio, num_mes )
                ini = fecha.beginning_of_month
                fin = fecha.end_of_month

                result_todo.push Diezmo.where(dat_diezmo_fecharegistro:( ini .. fin)).sum(:dec_diezmo_monto).to_f

                categorias = [ meses[num_mes-1]]
            end
        else

            #por año

            fecha = DateTime.new(anio)

            ini = fecha.at_beginning_of_year
            fin = fecha.at_end_of_year

            result_todo.push Diezmo.where(dat_diezmo_fecharegistro:( ini .. fin)).sum(:dec_diezmo_monto).to_f

        end
            
        titulo = "Diezmos"
        subtitulo = "del mes"
        ejey = "Soles"
        nombre_serie = "Iglesia"

        result = generar_json_column(titulo, subtitulo, ejey, nombre_serie, categorias, result_todo)

        render :json => result , :status => :ok
    end

    def ofrenda

    end

    def recuperar_data_ofrenda

         mes = true
        semana = false
        num_mes = 0
        num_semana = 1
        anio = 2013

        meses = [ "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"]

        categorias = nil

        result_todo = []

        if mes == true and semana == true



        elsif mes == true and semana == false

            if num_mes == 0
                # para todos los meses
                lista = (0 .. 11 ).to_a

                lista.each{ |i|

                    fecha = DateTime.new(anio, i + 1)
                    ini = fecha.beginning_of_month
                    fin = fecha.end_of_month

                    result_todo.push Diezmo.where(dat_diezmo_fecharegistro:( ini .. fin)).sum(:dec_diezmo_monto).to_f

                }
                categorias = meses

            else
                #para un mes en especifico
                fecha = DateTime.new(anio, num_mes )
                ini = fecha.beginning_of_month
                fin = fecha.end_of_month

                result_todo.push Diezmo.where(dat_diezmo_fecharegistro:( ini .. fin)).sum(:dec_diezmo_monto).to_f

                categorias = [ meses[num_mes-1]]
            end
        else

            #por año

            fecha = DateTime.new(anio)

            ini = fecha.at_beginning_of_year
            fin = fecha.at_end_of_year

            result_todo.push Diezmo.where(dat_diezmo_fecharegistro:( ini .. fin)).sum(:dec_diezmo_monto).to_f

        end
            
        titulo = "Ofrendas"
        subtitulo = "del mes"
        ejey = "Soles"
        nombre_serie = "Iglesia"

        result = generar_json_column(titulo, subtitulo, ejey, nombre_serie, categorias, result_todo)

        render :json => result , :status => :ok

    end

    def 

    def membresia

    end

    def asistencia

    end

    def recuperar_data_asistencia

        serv =Servicio.first
        mes = true
        semana = false
        num_mes = 0
        num_semana = 1
        anio = 2013

        if mes == true and semana == true

        elsif mes == true and semana == false

        else

        end
            



    end

end
