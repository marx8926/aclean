class Persona < ActiveRecord::Base
	belong_to :iglesia
	has_many :telefonos
	belong_to :persona
	has_many :nivel_crecimientos
	has_many :diezmos
	has_many :asistencias
	has_many :direccions
end
