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

    def ofrenda

    end

    def membresia

    end

    def asistencia

    end
    
end
