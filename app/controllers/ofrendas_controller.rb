require "date"

class OfrendasController < ApplicationController

	before_filter :authenticate_user!

	def index
		

	end

	def guardar

		ActiveRecord::Base.transaction do
			begin

				fecha = params[:fecha]
				monto = params[:monto]
				servicio = params[:servicio]


				@ofrenda = Ofrenda.new
				@ofrenda.dec_ofrenda_monto = monto
				@ofrenda.dec_ofrenda_fecharegistro = fecha

				@serv = Servicio.find(servicio)

				@ofrenda.servicio = @serv
				@ofrenda.save!

			rescue 
				raise ActiveRecord::Rollback
			end
		end

		render :json => "ok" , :status => :ok

	end

	def recuperar_init

		todo = []

		ofrendas = Ofrenda.last(300)

		if ofrendas.length > 0

			ofrendas.each{ |x|

				temp = {}
				temp["monto"] = x[:dec_ofrenda_monto]
				temp["registro"] = x[:dec_ofrenda_fecharegistro]
				serv = x.servicio

				turn = Turno.where("servicio_id" => serv.int_servicio_id)

				#temporal para almacenar turnos de servicio

				#if 
				#temp["servicio"] = serv_s

			}

		end

		return :json => todo, :status => :ok
	end


	def recuperar_turno(id)
		todo = []
		
		result = Turno.where("servicio_id" => id )
		result.each {|p| 
			todo.push [ p.var_turno_horainicio, p.int_turno_id ]
		}

		return :json => result, :status => :ok
	end

end
