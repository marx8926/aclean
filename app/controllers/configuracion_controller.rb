class ConfiguracionController < ApplicationController

	before_filter :authenticate_user!

	def datos_generales
		
	end
	
	def servicios
		
	end

	def lugar
		
	end

	def usuario
		
	end

	def guardar_lugar

		ActiveRecord::Base.transaction do
			begin
				lugar = Lugar.new({
					:var_lugar_descripcion => params[:descripcion] ,
					:var_lugar_estado => '1'
					})

				lugar.save!

			rescue
				raise ActiveRecord::Rollback
			end
		end

		render :json => "ok" , :status => :ok

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
					turno = Turno.new({:var_turno_horainicio => data[:var_turno_horainicio], :int_turno_dia => data[:int_turno_dia], :servicio => servicio})
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
		arrayserv = []
		servicio.each{ |x|
			serv = {}
			serv['int_servicio_id'] = x.int_servicio_id
			serv['var_servicio_nombre'] = x.var_servicio_nombre
			serv['int_servicio_tipo'] = x.int_servicio_tipo
			serv['var_servicio_acciones'] = ""
			if x.int_servicio_tipo == 1
				serv['int_servicio_tipo_desc'] = "Culto General"
			else
				serv['int_servicio_tipo_desc'] = "Culto Jovenes"
			end

			if x != nil
				tshow= ""
				arrayturn = []
				turnos = Turno.joins(:servicio).where("servicio_id" => x.int_servicio_id)
				turnos.each{ |y|
					case y[:int_turno_dia]
						when 0
							dia = "Domingo"
						when 1
							dia = "Lunes"
						when 2
							dia = "Martes"
						when 3
							dia = "Miercoles"
						when 4
							dia = "Jueves"
						when 5
							dia = "Viernes"
						else
							dia = "Sabado"
					end
					tshow = tshow + "<p>"+dia+" - "+y[:var_turno_horainicio]+":00</p>"
					arrayturn.push y
				}			
			end
			serv['turnos'] = arrayturn
			serv['turnoshow'] = tshow
			arrayserv.push serv
		}
		render :json => { :aaData => arrayserv }, :status => :ok
	end

	def drop_servicio
		servicio = Servicio.find(params[:idservicio])
		Turno.destroy_all(servicio_id: params[:idservicio])
		servicio.destroy
		render :json => { :datos => params[:idservicio]}, :status => :ok
	end

	def editar_servicio
		form = params[:formulario]
		otherdata = params[:otherdata]
		servicio = Servicio.find(form[:idservicio])
		servicio.update(:var_servicio_nombre => form[:nombre], :int_servicio_tipo => form[:tipo])
		Turno.destroy_all(servicio_id: form[:idservicio])
		otherdata.each{ |x|
					data = x.last
					turno = Turno.new({:var_turno_horainicio => data[:var_turno_horainicio], :int_turno_dia => data[:int_turno_dia], :servicio => servicio})
					turno.save!
		}
		render :json => { :datos => params}, :status => :ok
	end
end
