require "date"
require "json"

class OfrendasController < ApplicationController

	before_filter :authenticate_user!

	def index
		

	end

	def guardar

		ActiveRecord::Base.transaction do
			begin

				fecha = params[:fecha]

				monto = params[:monto]
				#servicio = params[:servicio]
				turno = params[:turno]


				@ofrenda = Ofrenda.new
				@ofrenda.dec_ofrenda_monto = monto
				@ofrenda.dec_ofrenda_fecharegistro = fecha


				@turn = Turno.find(turno)

				@ofrenda.turno = @turn
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
			}

		end

		return :json => todo, :status => :ok
	end


	def recuperar_turno
		todo = []

		id = params[:id]
		
		result = Turno.where("servicio_id" => id )
		result.each {|p|
			t = {}
			t['inicio'] =  p.var_turno_horainicio
			t['turno'] = p.int_turno_id
			todo.push t
		}

		render :json => todo, :status => :ok
	end

end
