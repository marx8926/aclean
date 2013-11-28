require "date"
require "json"

class GanarController < ApplicationController

	def index

	end

	def guardar_miembro

		form = params[:formulario]
		tabla = params[:tabla]

		ActiveRecord::Base.transaction do
			begin
				persona = Persona.new({:dat_persona_fecregistro => form[:fec_conversion] , 
					:var_persona_nombres => form[:nombre] , :var_persona_apellidos => form[:apellido],
					:int_persona_edad => form[:edad] , :dat_persona_fecNacimiento => form[:fec_nac] ,
					:var_persona_profesion => form[:profesion] , :var_persona_ocupacion => form[:ocupacion],
					:var_persona_sexo => form[:sexo] , :var_persona_dni => form[:dni],
					:var_persona_estado => "1", :var_persona_email => form[:email] ,
					:var_persona_invitado => form[:invitado] , :iglesia => Iglesia.first , :lugar => Lugar.find(form[:lugar]) })

				persona.save!


				direccion = Direccion.new({ :var_direccion_descripcion => form[:direccion], 
					:var_direccion_referencia => form[:referencia],
					:dou_direccion_longitud => nil, :dou_direccion_latitud => nil , 
					:var_direccion_estado => "1", :ubigeo => Ubigeo.find(form[:distrito]),
					:persona => persona
					})

				nivel = NivelCrecimiento.new({ :int_nivelcrecimiento_escala => 1 ,
					:int_nivelcrecimiento_estadoactual => 1,
					:persona => persona})

				peticion = Peticion.new({ :var_peticion_motivooracion => form[:mot_oracion],
					:persona => persona , :dat_peticion_fecha => form[:fec_conversion]
					})


				

				direccion.save!
				nivel.save!
				peticion.save!
				
				if tabla != nil
					tabla.each{ |y|
						x = y.last
						telefono = Telefono.new({:int_telefono_tipo => x[:tipo_val],
						:var_telefono_codigo => x[:codigo],
						:var_telefono => x[:tel], :persona => persona})
						telefono.save!
					}
				end

			rescue
				raise ActiveRecord::Rollback
			end

		end

		render :json => "ok" , :status => :ok

	end


	def guardar_visita

		form = params[:formulario]
		tabla = params[:tabla]

		ActiveRecord::Base.transaction do
			begin

				persona = Persona.new({:dat_persona_fecregistro =>  DateTime.now(), :var_persona_nombres => form[:nombrev] , 
					:var_persona_apellidos => form[:apellidov],
					:int_persona_edad => form[:edadv] , :dat_persona_fecNacimiento => nil ,
					:var_persona_profesion => nil , :var_persona_ocupacion => nil,
					:var_persona_sexo => nil , :var_persona_dni => nil,
					:var_persona_estado => "1", :var_persona_email => nil ,
					:var_persona_invitado => form[:invitadov] , :iglesia => Iglesia.first , 
					:lugar => nil
					  })

				persona.save!

				peticion = Peticion.new({ :var_peticion_motivooracion => form[:mot_oracionv],
					:persona => persona , :dat_peticion_fecha => DateTime.now()
					})

				nivel = NivelCrecimiento.new({ :int_nivelcrecimiento_escala => 0 , :int_nivelcrecimiento_estadoactual => 1,
					:persona => persona})

				 

				peticion.save!				
				nivel.save!

				if tabla != nil
					tabla.each{ |y|
						x = y.last
						telefono = Telefono.new({:int_telefono_tipo => x[:tipo_valv],
						:var_telefono_codigo => x[:codigov],
						:var_telefono => x[:telv], :persona => persona})

						telefono.save!
					}
				end

				
			rescue
				raise ActiveRecord::Rollback

			end
		end

		render :json => "ok" , :status => :ok

	end

	def recuperar_personas_init

		persona = Persona.all.limit 300

		todo = []

		persona.each{ |x|

			t = {}
			t['persona'] = x.int_persona_id

			
			telefono = Telefono.joins(:persona).where("persona_id" => x.int_persona_id)
			nivel = NivelCrecimiento.joins(:persona).where("persona_id" => x.int_persona_id)

			t['telefono'] = telefono
			t['nivel'] = nivel
			todo.push(t)

		}
		
		return :json => { "aData" => todo} , :status => :ok




	end

end
