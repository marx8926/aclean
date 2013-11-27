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
				servicio = Servicio.new({:var_servicio_nombre => form[:nombre], :int_servicio_tipo => form[:tipo]})	
				servicio.save!

				otherdata.each{ |x|
					data = x.last
					turno = Turno.new({:var_turno_horainicio => data[:hora], :int_turno_dia => data[:dia], :servicio => servicio})
					turno.save!
				}
			rescue
        render :json => nil , :status => :internal_server_error
				raise ActiveRecord::Rollback
			end
		end
    render :json => {:data => otherdata, :formulario => form[:nombre]}, :status => :ok			
	end

	def test
		render :json => { :se => Servicio.all , :mas => "dkjdfkfdj"}
	end

	def recuperar_servicio

		servicio = Servicio.all
		serv = {}
		servicio.each{ |x|
			serv['int_servicio_id'] = x.int_servicio_id
			serv['var_servicio_nombre'] = x.var_servicio_nombre
			serv['int_servicio_tipo'] = x.int_servicio_tipo


			

			if x != nil
				t = {}
				turno = Turno.find_by servicio: x
				t['int_turno_id'] = turno[:int_turno_id]
				t['var_turno_horainicio'] = turno[:var_turno_horainicio]
				t['int_turno_dia'] = turno[:int_turno_dia]
				
			end

			serv['turnos'] = t
		}
		render :json => { :aaData => serv }, :status => :ok
	end

end
