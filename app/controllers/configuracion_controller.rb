class ConfiguracionController < ApplicationController

	before_filter :authenticate_user!

	def datos_generales
		
	end
	
	def servicios
		
	end

	def lugar
		
	end

	def guardar_servicio
		form = params[:formulario]
		otherdata = params[:otherdata]
		ActiveRecord::Base.transaction do
			begin
				@servicio = Servicio.new({:var_servicio_nombre => form[:nombre], :int_servicio_tipo => form[:tipo]})	
				@servicio.save!
			rescue
        render :json => nil , :status => :internal_server_error
				raise ActiveRecord::Rollback
			end
		end
    render :json => {:data => otherdata.first, :formulario => form[:nombre]}, :status => :ok			
	end
  
	def test
		render :json => { :se => Servicio.all , :mas => "dkjdfkfdj"}
	end

	def recuperar_servicio
		render :json => { :aaData => Servicio.all }, :status => :ok
	end

end
