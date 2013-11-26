class ConfiguracionController < ApplicationController

	before_filter :authenticate_user!

	def datos_generales
		
	end
	
	def servicios
		
	end

	def guardar_servicio

		@servicio = Servicio.new({:var_servicio_nombre => params[:nombre], :int_servicio_tipo => params[:tipo]})

		if @servicio.save
			flash[:success] = 'Registro con exito'
		else
			flash[:error] = 'Error en registro'
		end

		redirect_to configuracion_servicios_path
	end

end
