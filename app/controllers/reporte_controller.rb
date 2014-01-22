class ReporteController < ApplicationController
	def diezmo

    end

    def ofrenda

    end

    def membresia

    end

    def asistencia

    end

    def asistenciareporte
        @asistencia = ActiveRecord::Base.connection.execute("SELECT * FROM view_get_rpt_asistencia_servicio where fecha BETWEEN '"+params[:inicio]+"' and '"+params[:fin]+"'")
        respond_to do |format|
            format.xls
        end
    end

    def servicios

    end
end
