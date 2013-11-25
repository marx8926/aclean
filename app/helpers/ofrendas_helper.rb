module OfrendasHelper

	def servicios_select
		select("", "servicio", Servicio.all.collect {|p| [ p.var_servicio_nombre, p.int_servicio_id ] }, {}, { class: "form-control"})
	end
end
