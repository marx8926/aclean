class Persona < ActiveRecord::Base
	belongs_to :iglesia
	has_many :telefonos
	belongs_to :persona
	has_many :nivel_crecimientos
	has_many :diezmos
	has_many :asistencias
	has_many :direccions
end
