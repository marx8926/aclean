class Servicio < ActiveRecord::Base
	has_many: turnos
	has_many: ofrendas
	has_many: asistencias
end
