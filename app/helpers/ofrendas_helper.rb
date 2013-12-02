module OfrendasHelper

	def servicios_select
		select("", "servicio", Servicio.all.collect {|p| [ p.var_servicio_nombre, p.int_servicio_id ] },{ include_blank: true }, { class: "form-control"})
	end

	
end
