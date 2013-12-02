module OfrendasHelper

	def servicios_select
		select("", "servicio", Servicio.all.collect {|p| [ p.var_servicio_nombre, p.int_servicio_id ] }, {}, { class: "form-control"})
	end

	def turnos_select(id, nombre)
		select("", nombre , Turno.where("servicio_id" => id ).collect {|p| [ p.var_turno_horainicio, p.int_turno_id ] }, {}, { class: "form-control"})
	end
end
