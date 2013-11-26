require "date"

class GanarController < ApplicationController

	def index

	end

	def guardar_miembro

		ActiveRecord::Base.transaction do
			begin
				persona = Persona.new({:dat_persona_fecRegistro => params[:fec_conversion] , 
					:var_persona_nombres => params[:nombre] , :var_persona_apellidos => params[:apellido],
					:int_persona_edad => params[:edad] , :dat_persona_fecNacimiento => params[:fec_nac] ,
					:var_persona_profesion => params[:profesion] , :var_persona_ocupacion => params[:ocupacion],
					:var_persona_sexo => params[:sexo] , :var_persona_dni => params[:dni],
					:var_persona_estado => "1", :var_persona_email => params[:email] ,
					:var_persona_invitado => params[:invitado] , :iglesia => Iglesia.first , :lugar => Lugar.find(params[:lugar]) })


				if persona.save!

					direccion = Direccion.new({ :var_direccion_descripcion => params[:direccion], :var_direccion_referencia => params[:referencia],
						:dou_direccion_longitud => nil, :dou_direccion_latitud => nil , 
						:var_direccion_estado => "1", :ubigeo => Ubigeo.find(params[:distrito]),
						:persona => persona
						})

					nivel = NivelCrecimiento.new({ :int_nivelcrecimiento_escala => 1 , :int_nivelcrecimiento_estadoActual => 1,
						:persona => persona})

					peticion = Peticion.new({ :var_peticion_motivoOracion => params[:mot_oracion],
						:persona => persona , :dat_peticion_fecha => params[:fec_conversion]
						})

					telefono = Telefono.new({:int_telefono_tipo => 0, :var_telefono_codigo => "044",
						:var_telefono => "238627", :persona => persona})

					if (direccion.save! and nivel.save!) and ( peticion.save! and telefono.save! )
						flash[:success] = 'Registro con exito'
					else
						flash[:error] = 'Error en registro'
						raise ActiveRecord::Rollback
					end

				else					
					flash[:error] = 'Error en registro'
					raise ActiveRecord::Rollback
				end
			rescue
				raise ActiveRecord::Rollback
			end

		end

		redirect_to persona_path

	end

	def guardar_visita

		ActiveRecord::Base.transaction do
			begin

				persona = Persona.new({:dat_persona_fecRegistro =>  DateTime.now(), :var_persona_nombres => params[:nombrev] , :var_persona_apellidos => params[:apellidov],
					:int_persona_edad => params[:edadv] , :dat_persona_fecNacimiento => nil ,
					:var_persona_profesion => nil , :var_persona_ocupacion => nil,
					:var_persona_sexo => nil , :var_persona_dni => nil,
					:var_persona_estado => "1", :var_persona_email => nil ,
					:var_persona_invitado => params[:invitadov] , :iglesia => Iglesia.first , 
					:lugar => nil
					  })

				if persona.save!

					peticion = Peticion.new({ :var_peticion_motivoOracion => params[:mot_oracionv],
						:persona => persona , :dat_peticion_fecha => DateTime.now()
						})

					nivel = NivelCrecimiento.new({ :int_nivelcrecimiento_escala => 0 , :int_nivelcrecimiento_estadoActual => 1,
						:persona => persona})

					telefono = Telefono.new({:int_telefono_tipo => 0, :var_telefono_codigo => "044",
						:var_telefono => "238627", :persona => persona}) 

					if peticion.save! and telefono.save! and nivel.save!
						flash[:success] = 'Registro con exito'
					else
						flash[:error] = 'Error en registro'
						raise ActiveRecord::Rollback
					end

				else
					flash[:error] = 'Error en registro'
					raise ActiveRecord::Rollback
				end

			rescue
				flash[:error] = 'Error en registro'
				raise ActiveRecord::Rollback

			end
		end

		redirect_to persona_path

	end

end
