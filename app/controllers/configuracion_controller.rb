require "date"

class ConfiguracionController < ApplicationController

	before_filter :authenticate_user!

	def datos_generales
		
		@igle = Iglesia.first
		@pas = nil
		if @igle.nil? == false
			@pas = NivelCrecimiento.where("int_nivelcrecimiento_escala" => 2)
		end

		[@igle, @pas]
	end
	
	def servicios
		
	end

	def lugar
		
	end

	def usuario
		
	end

	# 1: persona
	# 2: diezmo
	# 3: ofrenda
	# 4: asistencia
	# 5: informacion
	# 6: configuracion

	def guardar_usuario
		ActiveRecord::Base.transaction do
			begin

				user = User.create!(
					:email => params[:email],
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
				end

				if params[:diezmo].nil? == false
					diezmo = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "diezmo")
						)
				end

				if params[:ofrenda].nil? == false 
					ofrenda = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "ofrenda")
						)
				end

				if params[:asistencia].nil? == false 
					asistencia = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "asistencia")
						)
				end

				if params[:informacion].nil? == false
					informacion = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "informacion")
						)
				end

				if params[:configuracion].nil? == false
					configuracion = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "configuracion")
						)
				end
					
			rescue
				raise ActiveRecord::Rollback
			end
		end
		render :json => {:resp => params }, :status => :ok
	end

	def recuperar_usuario
		usuarios = User.all
		render :json => {:aaData => usuarios} , :status => :ok
	end

  def recuperar_menu_usuario
    usuarios_menus = UsuarioMenu.where("user_id" => params[:id])
    menus = []
    usuarios_menus.each{ |x|
    	menu = Menu.find(x[:menu_id])
    	menus.push(menu)
    }
    render :json => menus , :status => :ok
  end

  def editar_usuario
  	ActiveRecord::Base.transaction do
			begin
		  	user = User.lock.find(params[:id_usuario])
		  	user.update!(
		  				:email => params[:email],
							:password => params[:password] ,
							:var_usuario_nombre => params[:nombre],
							:var_usuario_apellido => params[:apellido],
							:var_usuario_documento => params[:num_doc])
		  	UsuarioMenu.destroy_all("user_id" => params[:id_usuario])

		  	if params[:persona].nil? == false
					persona = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "persona")
						)
				end

				if params[:diezmo].nil? == false
					diezmo = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "diezmo")
						)
				end

				if params[:ofrenda].nil? == false 
					ofrenda = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "ofrenda")
						)
				end

				if params[:asistencia].nil? == false 
					asistencia = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "asistencia")
						)
				end

				if params[:informacion].nil? == false
					informacion = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "informacion")
						)
				end

				if params[:configuracion].nil? == false
					configuracion = UsuarioMenu.create!(
						:user => user,
						:menu => Menu.find_by(var_menu_nombre: "configuracion")
						)
				end
		  rescue
				raise ActiveRecord::Rollback
			end
		end
		render :json => {:resp => "ok" }, :status => :ok
  end

	def guardar_lugar

		form = params[:formulario]
		ActiveRecord::Base.transaction do
			begin
				lugar = Lugar.new({
					:var_lugar_descripcion => form[:descripcion] ,
					:var_lugar_estado => '1'
					})
				lugar.save!
			rescue
				raise ActiveRecord::Rollback
			end
		end
		render :json => {:resp => "ok" }, :status => :ok

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

	def drop_lugar
		lugar = Lugar.lock.find(params[:idlugar])
		Lugar.destroy_all(int_lugar_id: params[:idlugar])
		lugar.destroy
		render :json => { :datos => params[:idlugar]}, :status => :ok
	end

	def editar_lugar
		form = params[:formulario]
		lugar = Lugar.lock.find(form[:idlugar])
		lugar.update!(:var_lugar_descripcion => form[:descripcion])
		render :json => {:resp => "ok" }, :status => :ok
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
				turnos = Turno.where("servicio_id" => x.int_servicio_id)
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

          			tshow = tshow + "<p>"+dia+" : "+y[:var_turno_horainicio]+" - "+ y[:var_turno_horafin]+" </p>"
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

		pastor1 = nil
		pastor2 = nil

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

					psn1 = params[:psn_val1]
					psn2 = params[:psn_val2]

					if psn1.nil? == false and psn1.length > 0
						pastor1 = Persona.find(psn1)
					end

					if psn2.nil? == false and psn2.length > 0
						pastor2 = Persona.find(psn2)
					end


					# actualizacion de niveles anteriores 

					if pastor1 != nil 
						NivelCrecimiento.where("persona_id"=> pastor1.int_persona_id).update_all(int_nivelcrecimiento_estadoactual: 0)


						#guardamos un nuevo nivel de crecimiento
						nivel_pastor1 = NivelCrecimiento.new({ :int_nivelcrecimiento_escala => 2 ,
						:int_nivelcrecimiento_estadoactual => 1,
						:persona => pastor1})

						nivel_pastor1.save!
					end


					#actualizar al pastor 2

					if pastor2 != nil

						NivelCrecimiento.where("persona_id"=> pastor2.int_persona_id).update_all(int_nivelcrecimiento_estadoactual: 0)


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

		render :json => { :resp => params }, :status => :ok

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
		servicio = Servicio.lock.find(params[:idservicio])
		Turno.destroy_all(servicio_id: params[:idservicio])
		servicio.destroy
		render :json => { :datos => params[:idservicio]}, :status => :ok
	end

	def editar_servicio
		form = params[:formulario]
		otherdata = params[:otherdata]
		servicio = Servicio.lock.find(form[:idservicio])
		servicio.update(:var_servicio_nombre => form[:nombre], :int_servicio_tipo => form[:tipo])


		#Turno.where(servicio_id: form[:idservicio])

		otherdata.each{ |x|
					data = x.last
					turno = Turno.find_or_create_by!({:var_turno_horafin => data[:var_turno_horafin],
						:var_turno_horainicio => data[:var_turno_horainicio], :int_turno_dia => data[:int_turno_dia], :servicio => servicio})
					
		}
		render :json => { :datos => params}, :status => :ok
	end

end
