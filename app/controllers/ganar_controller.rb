class GanarController < ApplicationController

	def index

	end

	def guardar

		persona = Persona.new


		if persona.save

		else

		end

		redirect_to persona_path

	end

	
end
