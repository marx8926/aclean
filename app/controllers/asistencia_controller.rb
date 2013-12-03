require "date"
require "json"

class AsistenciaController < ApplicationController

	before_filter :authenticate_user!

	def index
		
	end

	def guardar

		form = params[:formulario]
		tabla = params[:tabla]
		serv = nil

		ActiveRecord::Base.transaction do

			begin

				serv = Servicio.find(form[:servicio])
				
				if tabla.length > 0 && serv.nil? == false

					tabla.each{ |y|
						x = y.last
						asist = Asistencia.new({
							:dat_asistencia_fecregistro => DateTime.now(),
							:dat_asistencia_fecasistencia => form[:fecha],
							:int_asistencia_categoria => x[:categoria],
							:int_asistencia_cantidad => x[:asistente],
							:servicio => serv
							})

						asist.save!
					}

				end

			rescue
				raise ActiveRecord::Rollback
			end

		end
		
		render :json => { :resp => "ok" } , :status => :ok
	end

	def recuperar_init

		asistencia = Asistencia.select([:int_asistencia_id, :dat_asistencia_fecasistencia, :int_asistencia_categoria, :servicio_id, :int_asistencia_cantidad]).group(:dat_asistencia_fecasistencia, :int_asistencia_categoria, :servicio_id, :int_asistencia_id).last(300)
		todo = []

		if asistencia.length > 0

			asistencia.each{ |x|
				temp = {}
				categoria = ""
				servicio = x.servicio
				if servicio != nil
					servicio = servicio[:var_servicio_nombre]
				end
				temp['servicio'] = servicio

				temp['fecha'] = x[:dat_asistencia_fecasistencia].strftime("%d/%m/%Y")

				case x[:int_asistencia_categoria]
				when 0
					categoria = "Mujeres Jovenes"
				when 1
					categoria = "Hombres Jovenes"
				when 2
					categoria = "Mujeres"
				when 3
					categoria = "Hombres"

				end

				temp['categoria'] = categoria


				temp['asistencia'] = x[:int_asistencia_cantidad]

				todo.push temp

			}
		end

		render :json => { "aaData" => todo } , :status => :ok

	end


	def recuperar_filtro_asistencia

		inicio = params[:inicio]
		fin = params[:fin]

		asistencia = Asistencia.select([:int_asistencia_id, :dat_asistencia_fecasistencia, :int_asistencia_categoria,
		 :servicio_id, :int_asistencia_cantidad]).where(dat_asistencia_fecasistencia: (inicio .. fin)).group(:dat_asistencia_fecasistencia,
		  :int_asistencia_categoria, :servicio_id, :int_asistencia_id).last(300)
		todo = []

		if asistencia.length > 0

			asistencia.each{ |x|
				temp = {}
				categoria = ""
				servicio = x.servicio
				if servicio != nil
					servicio = servicio[:var_servicio_nombre]
				end
				temp['servicio'] = servicio

				temp['fecha'] = x[:dat_asistencia_fecasistencia].strftime("%d/%m/%Y")

				case x[:int_asistencia_categoria]
				when 0
					categoria = "Mujeres Jovenes"
				when 1
					categoria = "Hombres Jovenes"
				when 2
					categoria = "Mujeres"
				when 3
					categoria = "Hombres"

				end

				temp['categoria'] = categoria


				temp['asistencia'] = x[:int_asistencia_cantidad]

				todo.push temp

			}
		end

		render :json => { "aaData" => todo } , :status => :ok

	end
end
