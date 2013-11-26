class ConfiguracionController < ApplicationController

	before_filter :authenticate_user!

	def datos_generales
		
	end
	
	def servicios
		
	end

	def lugar
		
	end

	def guardar_servicio

		@servicio = Servicio.new({:var_servicio_nombre => params[:nombre], :int_servicio_tipo => params[:tipo]})

		if @servicio.save

		else
			
		end

		render :json => @servicio , :status => "ok"
	end

	def test
		render :js => "alert('error saving comment');"
	end

end
