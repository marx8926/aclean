require "date"
require "json"

class AsistenciaController < ApplicationController
	def index
		
	end

	def guardar

		ActiveRecord::Base.transaction do
			begin
      			asist = Asistencia.new({:dat_asistencia_fecRegistro => DateTime.now(),
      				:dat_asistencia_fecAsistencia => DateTime.now(), :servicio => Servicio.find(params[:servicio]),
      				:int_asistencia_categoria => 0 })
      			if asist.save!
      				flash[:success] = 'Registro con exito'
      			else
      				flash[:error] = 'Error en registro'
      				raise ActiveRecord::Rollback
      			end

			rescue
				flash[:error] = 'Error en registro'
				raise ActiveRecord::Rollback
			end
		end

		redirect_to asistencia_path
	end

end
