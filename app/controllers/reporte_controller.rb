class ReporteController < ApplicationController

    layout 'base'
    $mactive = 'mreportes'

	def diezmo
        @titulo = 'Diezmo - Reportes'
    end

    def ofrenda
        @titulo = 'Ofrenda - Reportes'
    end

    def membresia
        @titulo = 'Miembros y Visitantes - Reportes'
    end

    def asistencia
        @titulo = 'Asistencia - Reportes'
    end

    def asistenciareporte
        @asistencia = ActiveRecord::Base.connection.execute("SELECT * FROM view_get_rpt_asistencia_servicio where fecha BETWEEN '"+params[:inicio]+"' and '"+params[:fin]+"'")
        respond_to do |format|
            format.xls
        end
    end

    def servicios
        @titulo = 'Servicios - Reportes'
    end
end
