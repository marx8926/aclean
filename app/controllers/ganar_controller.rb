require "date"
require "json"

class GanarController < ApplicationController

	before_filter :authenticate_user!

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

	def recuperar_personas_inicio

		persona = Persona.all.limit 300

		todo = []

		if persona.length > 0

			
			persona.each{ |x|
				t = {}
				t['nombrecompleto'] = x[:var_persona_nombres]+" "+x[:var_persona_apellidos]
				t['registro'] = x[:created_at].strftime("%d/%m/%Y")
				t['persona_data'] = x

				if x[:dat_persona_fecNacimiento].nil? == false
					t['fecnacimiento'] = x[:dat_persona_fecNacimiento].strftime("%d/%m/%Y")
				else
					t['fecnacimiento'] = nil
				end

				if x[:dat_persona_fecregistro].nil? == false
					t['convertido'] = x[:dat_persona_fecregistro].strftime("%d/%m/%Y")
				else
					t['convertido'] = nil
				end

				telefono = Telefono.joins(:persona).where("persona_id" => x[:int_persona_id])
				nivel = NivelCrecimiento.joins(:persona).where({"persona_id" => x[:int_persona_id], "int_nivelcrecimiento_estadoactual" => 1 })

				tel = ""

				if telefono.length > 0
					telefono.each{ |i|


						temp = ( i[:var_telefono_codigo].nil? ? "" : i[:var_telefono_codigo] )+" "+ ( i[:var_telefono].nil? ? "" : i[:var_telefono] )
						tel = tel + "<p>" + temp + "</p>"
					}
				end
				
				level = nil

				nivel.each{ |i|

					case i[:int_nivelcrecimiento_escala]
					when 0
						level = "Visitante"
					when 1
						level = "Miembro"
					when 2
						level = "Pastor Principal"
					else
						level = "Administrador"
					end
				}

				t['var_persona_acciones']= ""
				t['telefono'] = tel
				t['telefono_data'] = telefono

				t['nivel'] = level

				#peticion

				peticion = Peticion.joins(:persona).where("persona_id" => x[:int_persona_id])


				t['peticion'] = peticion
				
				todo.push(t)
			}


		end

		render :json => { 'aaData' => todo }, :status => :ok
	end
end
