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

    def data_lineal_to_pie(data)

        result = []

        data.each{ |i|

            result.push [ i[:name], i[:data].sum ]
        }

        return result

    end

    def generar_json_pie(titulo, subtitulo, datos)
        
        result = {

            chart: {
                plotBackgroundColor: nil,
                plotBorderWidth: nil,
                plotShadow: false
            },
            title: {
                text: titulo
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
                name: subtitulo,
                data: datos
            }]
        }

        return result

    end

    def generar_json_column(titulo, subtitulo, ejey, serie="", categorias, result_todo)

                 
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
                    '<td style="padding:0"><b>{point.y:.1f} </b></td></tr>',
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
            series: result_todo
        }
        return result
    end

    def generar_json_lineas(titulo, subtitulo, ejey, categorias, result_todo, sufix)

                 
        result = {
            chart: {
                type: 'line'
            },            
            title: {
                text: titulo,
                x: -20
            },
            subtitle:{
                text: subtitulo,
                x: -20
            },
            xAxis: {
                categories: categorias
            },
            yAxis: {
                title: {
                    text: ejey
                },
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: sufix
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            series: result_todo
        }
        return result
    end

    def recuperar_data_diezmo


        meses = [ "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"]

        categorias = nil

        result_todo = []

        form = params[:formulario]
        anio = form[:anio].to_i
        mes = !form[:mes].nil?
        semana = !form[:semana].nil?


        if mes == true and semana == true

            num_mes = form[:mes_lista].to_i
            num_semana = form[:semana_lista].to_i

            fecha = DateTime.new(anio, num_mes)
            inicio = fecha.beginning_of_month
            final = fecha.end_of_month

            semanas = [ [inicio, (inicio+6).end_of_day], [inicio+7, (inicio+13).end_of_day], [inicio+14, (inicio+20).end_of_day] ,[inicio+21, final ] ]
            


            if num_semana == 0

                semanas.each{ |s|

                    ini = s.first
                    fin = s.last            
                    result_todo.push Diezmo.where(dat_diezmo_fecharegistro:( ini .. fin)).sum(:dec_diezmo_monto).to_f
                }
                categorias = ["1", "2", "3", "4"]
            else
                semana = semanas[ num_semana -1]
                ini = semana.first
                fin = semana.last

                categorias = [ num_semana.to_s ]
            end

        elsif mes == true and semana == false

            num_mes = form[:mes_lista].to_i

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
            categorias = [anio.to_s]
            result_todo.push Diezmo.where(dat_diezmo_fecharegistro:( ini .. fin)).sum(:dec_diezmo_monto).to_f
            
        end
            
        titulo = "Ofrendas"
        subtitulo = "del mes"
        ejey = "Soles"
        nombre_serie = "Iglesia"

        final = [{
                :name => titulo,
                :data => result_todo
                }]

        result = generar_json_column(titulo, subtitulo, ejey, nombre_serie, categorias, final )

        render :json => result, :status => :ok
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

        result = generar_json_column(titulo, subtitulo, ejey,  categorias, result_todo)

        render :json => result , :status => :ok

    end

    def 

    def membresia

    end

    def asistencia

    end

    def recuperar_asistencia_filtro(ini, fin, servicio=0 )

        if servicio == 0 #todos los servicios
            query = "SELECT int_asistencia_categoria, SUM(int_asistencia_cantidad) as cantidad FROM asistencia 
                WHERE dat_asistencia_fecasistencia between '#{ini}' and '#{fin}'
                GROUP BY int_asistencia_categoria
                ORDER BY int_asistencia_categoria asc"
        else 
            query = "SELECT int_asistencia_categoria, SUM(int_asistencia_cantidad) as cantidad FROM asistencia 
                WHERE servicio_id = '#{servicio}' and dat_asistencia_fecasistencia between '#{ini}' and '#{fin}'
                GROUP BY int_asistencia_categoria
                ORDER BY int_asistencia_categoria asc"
        end
        result = ActiveRecord::Base.connection.execute(query)

        final = []

        categorias = [ "Mujeres J." , "Hombres J.", "Mujeres", "Hombres"]
        asignar = []

        result.each{ |x|

            item = { 
                :name => categorias[x['int_asistencia_categoria'].to_i],
                :data => [x['cantidad'].to_i]                
            }
            
            final.push item
            asignar.push categorias[x['int_asistencia_categoria'].to_i]
        }

        # para la categoria restante

        if asignar.length != categorias.length

            dif = categorias - asignar

            dif.each{ |d|
                item =  {
                    :name => d,
                    :data => [ 0 ]
                }
                final.push item
            }

        end

        return final
    end

    def individual_to_grupal(lista, categoria)

        resultados = {}
        categoria.each{ |y|
            resultados[y] = []
        }

        lista.each{ |y|
            y.each{ |x|

                resultados[x[:name]].push x[:data].first
            }
        }

        #formateando al original

        final = []

        categoria.each{ |z|
            item = {
                :name => z,
                :data => resultados[z]
            }
            final.push item
        }
        return final

    end

    def split_data_plot_lines(data, categorias, titulos, subtitulos, ejeys)

        plot = []
        i = 0
        data.each{ |x| 

            result = generar_json_lineas(titulos[i], subtitulos[i], ejeys[i], categorias, [x], '#')
            plot.push result
            i = i+1
        }

        return plot

    end

    def recuperar_data_asistencia

        form = params[:formulario]
        data = nil
        mujj = 0
        muj = 0
        hom = 0
        homj = 0
        result = ""

        categorias = [ "Mujeres J." , "Hombres J.", "Mujeres", "Hombres"]
        meses = [ "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"]
        anio = form[:anio]

        if form[:servicio].length == 0
            servicio = 0
            subtitulo = "Todos los servicios"
        else 
            servicio = form[:servicio].to_i
            subtitulo = ""

        end
        

        ejey = "Asistencia"
        nombre_serie = "Iglesia"
        # Para cuando mes y semana estan chequeados
        if form[:mes].nil? == false and form[:semana].nil? == false
            #mes y semana
            resultados = []
            fecha = DateTime.new(anio.to_i, form[:mes_lista].to_i)
            inicio = fecha.beginning_of_month
            final = fecha.end_of_month

            semanas = [ [inicio, (inicio+6).end_of_day], [inicio+7, (inicio+13).end_of_day], [inicio+14, (inicio+20).end_of_day] ,[inicio+21, final ] ]
            titulos = [ "Asistencia "+ categorias[0] , "Asistencia "+ categorias[1] , "Asistencia "+ categorias[2],
                "Asistencia "+ categorias[3]]
            subtitulos = [subtitulo, subtitulo, subtitulo, subtitulo]
            ejeys = [ ejey , ejey, ejey, ejey]
            
            #Para cuando seleccionamos todas las semanas
            if form[:semana_lista] == "0"
                
                semanas.each{ |m|                   
                    ini = m.first
                    fin = m.last
                    data = recuperar_asistencia_filtro(ini, fin,servicio) 
                    resultados.push data
                }
                data = individual_to_grupal(resultados, categorias )
                titulo = "Asistencia General "+ anio + " Semanal"
            #Para cuando escogimos un numero de semana                 
            else
                num_semana = form[:semana_lista].to_i
                semana = semanas[ num_semana - 1]
                ini = semana.first
                fin = semana.last
                data = recuperar_asistencia_filtro(ini, fin,servicio)
                titulo = "Asistencia General "+ anio + " Semanal" 
                cnum = [ "1", "2", "3", "4"]  
                cat = [ cnum[num_semana-1] ]

            end

            result_general = generar_json_column(titulo, subtitulo, ejey, cat, data)
            split = split_data_plot_lines(data, cat, titulos, subtitulos, ejeys)
            pie = data_lineal_to_pie(data)
            resulto_pie = generar_json_pie(titulo, subtitulo, pie)
            result = [ result_general, resulto_pie, split[0], split[1], split[2], split[3] ]
        #Para cuando SOLO mes esta chequeado
        elsif form[:mes].nil? == false and form[:semana].nil? == true
            
            #para todos los servicios
            resultados = []
            #para cuando seleccionamos todos los meses
            if form[:mes_lista] == "0"
                
                meses_lista = (0 .. 11).to_a           
                
                meses_lista.each{ |m|
                    fecha = DateTime.new(anio.to_i, m+1)
                    ini = fecha.beginning_of_month
                    fin = fecha.end_of_month
                    data = recuperar_asistencia_filtro(ini, fin,servicio) 
                    resultados.push data
                }

                data = individual_to_grupal(resultados, categorias )
                titulo = "Asistencia General "+ anio + " Mensual" 
                categorias = meses              

            else #para un mes en especifico
                mes = form[:mes_lista]
                fecha = DateTime.new(anio.to_i, mes.to_i)
                ini = fecha.beginning_of_month
                fin = fecha.end_of_month
                data = recuperar_asistencia_filtro(ini, fin,servicio) 

                titulo = "Asistencia General "+ anio + " Mensual" 
                categorias = [meses[mes.to_i - 1]]

            end

            titulos = [ "Asistencia Mujeres J.", "Asistencia Hombres J.", "Asistencia Mujeres",
                "Asistencia Hombres"]
            subtitulos = [subtitulo, subtitulo, subtitulo, subtitulo]
            ejeys = [ ejey , ejey, ejey, ejey]
            result_general = generar_json_column(titulo, subtitulo, ejey, categorias, data)
            split = split_data_plot_lines(data, categorias, titulos, subtitulos, ejeys) 
            pie = data_lineal_to_pie(data)
            resulto_pie = generar_json_pie(titulo, subtitulo, pie)
            result = [ result_general, resulto_pie, split[0], split[1], split[2], split[3] ] 

        #Para cuando SOLO semana esta chequeado
        elsif form[:mes].nil? == true and form[:semana].nil? == false
            #solo semana

             #sin datos
             result = ""

        else            
            # por año Y todos los servicios
            fecha = DateTime.new(anio.to_i)
            
            ini = fecha.at_beginning_of_year
            fin = fecha.at_end_of_year

            data = recuperar_asistencia_filtro(ini, fin, servicio)               
            titulo = "Asistencia General "+ anio 
            categorias = [ anio ]

            general = generar_json_column(titulo, subtitulo, ejey, categorias, data)

            pie = data_lineal_to_pie(data)
            resulto_pie = generar_json_pie(titulo, subtitulo, pie)

            result = [ general, resulto_pie]
            
        end


        render :json => result, :status => :ok

    end

end
