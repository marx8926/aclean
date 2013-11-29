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
		arrayserv = []
		servicio.each{ |x|
			serv = {}
			serv['int_servicio_id'] = x.int_servicio_id
			serv['var_servicio_nombre'] = x.var_servicio_nombre
			serv['int_servicio_tipo'] = x.int_servicio_tipo
			if x.int_servicio_tipo == 1
				serv['int_servicio_tipo_desc'] = "Culto General"
			else
				serv['int_servicio_tipo_desc'] = "Culto Jovenes"
			end

			if x != nil
				arrayservt = []
				turno = Turno.joins(:servicio).where("servicio_id" => x.int_servicio_id)
				turno.each{ |y|
					t = {}
					t['int_turno_id'] = y[:int_turno_id]
					t['var_turno_horainicio'] = y[:var_turno_horainicio]
					t['int_turno_dia'] = y[:int_turno_dia]
					arrayservt.push y
				}			
			end

			serv['turnos'] = arrayservt
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

end
