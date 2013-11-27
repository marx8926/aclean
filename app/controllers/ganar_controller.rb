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
				persona = Persona.new({:dat_persona_fecRegistro => form[:fec_conversion] , 
					:var_persona_nombres => form[:nombre] , :var_persona_apellidos => form[:apellido],
					:int_persona_edad => form[:edad] , :dat_persona_fecNacimiento => form[:fec_nac] ,
					:var_persona_profesion => form[:profesion] , :var_persona_ocupacion => form[:ocupacion],
					:var_persona_sexo => form[:sexo] , :var_persona_dni => form[:dni],
					:var_persona_estado => "1", :var_persona_email => form[:email] ,
					:var_persona_invitado => form[:invitado] , :iglesia => Iglesia.first , :lugar => Lugar.find(form[:lugar]) })

				persona.save!

				direccion = Direccion.new({ :var_direccion_descripcion => form[:direccion], :var_direccion_referencia => form[:referencia],
					:dou_direccion_longitud => nil, :dou_direccion_latitud => nil , 
					:var_direccion_estado => "1", :ubigeo => Ubigeo.find(form[:distrito]),
					:persona => persona
					})

				nivel = NivelCrecimiento.new({ :int_nivelcrecimiento_escala => 1 , :int_nivelcrecimiento_estadoActual => 1,
					:persona => persona})

				peticion = Peticion.new({ :var_peticion_motivoOracion => form[:mot_oracion],
					:persona => persona , :dat_peticion_fecha => form[:fec_conversion]
					})


				

				direccion.save!
				nivel.save!
				peticion.save!
				
				tabla.each{ |y|
					x = y.last
					telefono = Telefono.new({:int_telefono_tipo => x[:tipo_val], :var_telefono_codigo => x[:codigo],
					:var_telefono => x[:tel], :persona => persona})
					telefono.save!
				}

			rescue
				raise ActiveRecord::Rollback
			end

		end

		render :json => "ok" , :status => :ok

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
