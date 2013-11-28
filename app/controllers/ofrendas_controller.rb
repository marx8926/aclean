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
				@ofrenda.save

			rescue
				raise ActiveRecord::Rollback
			end
		end

		render :json => "ok" , :status => :ok

	end


end
