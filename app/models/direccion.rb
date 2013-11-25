class Direccion < ActiveRecord::Base
	belong_to :ubigeo
	belong_to :persona
end
