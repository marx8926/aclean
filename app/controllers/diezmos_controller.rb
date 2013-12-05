class DiezmosController < ApplicationController
	def index

	end

	def guardar

		if params[:persona_hidden].length > 0
			ActiveRecord::Base.transaction do
			begin

				persona = Persona.lock.find(params[:persona_hidden])

				if persona.nil? == false
					diezmo = Diezmo.new({
						:dec_diezmo_monto => params[:monto],
						:var_diezmo_peticion => params[:peticion] ,
						:dat_diezmo_fecharegistro => params[:fecha],
						:persona => persona
					})

					diezmo.save!
				else
					render :json => {:resp => "bad" } , :status => :ok
				end

			rescue Exception => e
				raise ActiveRecord::Rollback
				render :json => {:resp => "bad" } , :status => :ok
			end
			end

			render :json => {:resp => "ok" } , :status => :ok
		else
			render :json => {:resp => "bad" } , :status => :ok
		end

	end


	def recuperar_inicio

		todo = []
		diezmo = Diezmo.last(300)

		if diezmo.length > 0
			diezmo.each{ |x|
				t = {}
				t['persona'] = x.persona.var_persona_nombres + " " + x.persona.var_persona_apellidos
				t['fecha'] = x[:dat_diezmo_fecharegistro].strftime("%d/%m/%Y")
				t['monto'] = x[:dec_diezmo_monto]
				t['peticion'] = x[:var_diezmo_peticion]
				todo.push t
			}
		end

		render :json => { 'aaData' => todo }, :status => :ok
	end

	def recuperar_diezmo_filtro

		todo = []
		diezmo = Diezmo.where(dat_diezmo_fecharegistro: ( params[:inicio] .. params[:fin] ))

		if diezmo.length > 0
			diezmo.each{ |x|

				t = {}

				t['persona'] = x.persona.var_persona_nombres + " " + x.persona.var_persona_apellidos
				t['fecha'] = x[:dat_diezmo_fecharegistro].strftime("%d/%m/%Y")
				t['monto'] = x[:dec_diezmo_monto]
				t['peticion'] = x[:var_diezmo_peticion]


				todo.push t
			}
		end

		render :json => { 'aData' => todo }, :status => :ok

	end
	
end
