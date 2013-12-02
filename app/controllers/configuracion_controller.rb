require "date"

class ConfiguracionController < ApplicationController

	before_filter :authenticate_user!

	def datos_generales
		
		@igle = Iglesia.first
	end
	
	def servicios
		
	end

	def lugar
		
	end

	def usuario
		
	end

	def guardar_usuario

		ActiveRecord::Base.transaction do
			begin

				user = User.create!(
					:email => params[:usuario],
					:password => params[:password] ,
					:var_usuario_nombre => params[:nombre],
					:var_usuario_apellido => params[:apellido],
					:var_usuario_documento => params[:num_doc]
				)

				if params[:persona].nil? == false

					persona = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "persona")
						)

				elsif params[:diezmos].nil? == false
					diezmo = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "diezmo")
						)

				elsif params[:ofrendas].nil? == false 
					ofrenda = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "ofrenda")
						)

				elsif params[:asistencia].nil? == false 
					asistencia = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "asistencia")
						)

				elsif params[:informacion].nil? == false
					informacion = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "informacion")
						)

				elsif params[:configuracion].nil? == false
					configuracion = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "configuracion")
						)
				end
					
			rescue
				raise ActiveRecord::Rollback
			end
		end

		render :json => params , :status => :ok
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

	def recuperar_lugar
		lugar = Lugar.all
		lugares =[]
		lugar.each{ |x|
			l={}
			l["int_lugar_id"] = x[:int_lugar_id]
			l["var_lugar_descripcion"] = x[:var_lugar_descripcion]
			l["var_lugar_estado"] = x[:var_lugar_estado]
			l["acciones"] = ""
			lugares.push l
		}
		render :json => {:aaData => lugares} , :status => :ok

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
					
					turno = Turno.new({:var_turno_horainicio => data[:var_turno_horainicio],
						:var_turno_horafin => data[:var_turno_horafin],
					 	:int_turno_dia => data[:int_turno_dia], :servicio => servicio})

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
		render :json => { :se => current_user , :mas => "dkjdfkfdj"}
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
					tshow = tshow + "<p>"+dia+" : "+y[:var_turno_horainicio]+":00 - "+ y[:var_turno_horafin]+":00 </p>"
					arrayturn.push y
				}			
			end
			serv['turnos'] = arrayturn
			serv['turnoshow'] = tshow
			arrayserv.push serv
		}
		render :json => { :aaData => arrayserv }, :status => :ok
	end


	def guardar_datos_generales

		ActiveRecord::Base.transaction do
			begin

				n = Iglesia.count()


				if n == 0

					igle = Iglesia.new({
					 :dat_iglesia_fecregistro => DateTime.now(),
					 :dat_iglesia_feccreacion => params[:fec_creacion] ,
					 :var_iglesia_telefono => params[:telefono],
					 :var_iglesia_siglas => params[:sigla] ,
					 :var_iglesia_nombre => params[:nombre],
					 :var_iglesia_direccion => params[:direccion] ,
					 :var_iglesia_referencia => params[:referencia] ,
					 :dou_iglesia_longitud => params[:longitud] ,
					 :dou_iglesia_latitud =>  params[:latitud] ,
					 :ubigeo => Ubigeo.find(params[:distrito])})

					pastor1 = Persona.find(params[:psn_val1])
					pastor2 = Persona.find(params[:psn_val2])


					# actualizacion de niveles anteriores 

					if pastor1 != nil 
						NivelCrecimiento.joins(:persona).where("persona_id"=> pastor1.int_persona_id).update_all(int_nivelcrecimiento_estadoactual: 0)


						#guardamos un nuevo nivel de crecimiento
						nivel_pastor1 = NivelCrecimiento.new({ :int_nivelcrecimiento_escala => 2 ,
						:int_nivelcrecimiento_estadoactual => 1,
						:persona => pastor1})

						nivel_pastor1.save!
					end


					#actualizar al pastor 2

					if pastor2 != nil

						NivelCrecimiento.joins(:persona).where("persona_id"=> pastor2.int_persona_id).update_all(int_nivelcrecimiento_estadoactual: 0)


						nivel_pastor2 = NivelCrecimiento.new({ :int_nivelcrecimiento_escala => 2 ,
						:int_nivelcrecimiento_estadoactual => 1,
						:persona => pastor2})

						nivel_pastor2.save!
					end


					NivelCrecimiento.destroy_all(int_nivelcrecimiento_estadoactual: 0 , int_nivelcrecimiento_escala: 2)

				else
					igle = Iglesia.first
					igle.dat_iglesia_feccreacion = params[:fec_creacion]
					igle.var_iglesia_telefono = params[:telefono]
					igle.var_iglesia_siglas = params[:sigla]
					igle.var_iglesia_direccion = params[:direccion]
					igle.var_iglesia_referencia = params[:referencia]
					igle.dou_iglesia_longitud = params[:longitud]
					igle.dou_iglesia_latitud =  params[:latitud]
					igle.ubigeo = Ubigeo.find(params[:distrito])

				end
				
				igle.save!
				
			rescue
				raise ActiveRecord::Rollback
			end
		end

		render :json => params, :status => :ok

	end


	def personas_autocomplete

		persona = Persona.all
		todo = []
		persona.each{ |p|

			item = { }
			
			item['label'] = p.var_persona_nombres+" "+p.var_persona_apellidos
			item['int_persona_id'] = p.int_persona_id
			todo.push item
		}

		render :json => todo , :status => :ok
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
