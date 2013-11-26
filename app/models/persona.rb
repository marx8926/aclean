class Persona < ActiveRecord::Base
	belongs_to :iglesia
	has_many :telefonos
	belongs_to :persona
	belongs_to :lugar
	has_many :nivel_crecimientos
	has_many :diezmos
	has_many :asistencias
	has_many :direccions
	has_many :peticions
end
