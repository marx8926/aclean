require "date"

class OfrendasController < ApplicationController

	before_filter :authenticate_user!

	def index
		

	end

	def guardar

		fecha = params[:fecha]
		monto = params[:monto]
		servicio = params[:servicio]


		@ofrenda = Ofrenda.new
		@ofrenda.dec_ofrenda_monto = monto
		@ofrenda.dec_ofrenda_fechaRegistro = fecha

		@serv = Servicio.find(servicio)

		@ofrenda.servicio = @serv

		if @serv!= nil && @ofrenda.save
			
			flash[:success] = 'Registro con exito'

		else
			flash[:error] = 'Error en registro'
		end

		redirect_to ofrendas_path

	end


end
