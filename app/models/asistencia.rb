class Asistencia < ActiveRecord::Base
	belongs_to :persona
	belongs_to :servicio
end
