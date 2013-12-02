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

				asist = Asistencia.new({
					:dat_asistencia_fecregistro =>  DateTime.now(),
					:dat_asistencia_fecasistencia => form[:fecha],
					:int_asistencia_categoria => tabla[:categoriaid],
					:int_asistencia_cantidad => x[:asistente],
					:servicio => serv
					})

				asist.save!

			rescue

			end

		end
		
		render :json => 'ok' , :status => :ok
	end

end
