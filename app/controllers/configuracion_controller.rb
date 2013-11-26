class ConfiguracionController < ApplicationController

	before_filter :authenticate_user!

	def datos_generales
		
	end
	
	def servicios
		
	end

	def lugar
		
	end

	def guardar_servicio

		ActiveRecord::Base.transaction do
			begin

				@servicio = Servicio.new({:var_servicio_nombre => params[:nombre], :int_servicio_tipo => params[:tipo]})

				if @servicio.save
					render :json => @servicio , :status => :ok
				else
					raise ActiveRecord::Rollback
					render :json => nil , :status => :internal_server_error
				end
			rescue
				raise ActiveRecord::Rollback
			end
		end				
	end

	def test
		render :json => Servicio.all
	end

end
