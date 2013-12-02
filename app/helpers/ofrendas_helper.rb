module OfrendasHelper

	def servicios_select
		select("", "servicio", Servicio.all.collect {|p| [ p.var_servicio_nombre, p.int_servicio_id ] }, {}, { class: "form-control"})
	end

	def turnos_select(id)

		todo = []
		
		result = Turno.where("servicio_id" => id )
		result.each {|p| 
			todo.push [ p.var_turno_horainicio, p.int_turno_id ]
		}

		options_for_select(todo)
	end
end
