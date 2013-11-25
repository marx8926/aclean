class Iglesia < ActiveRecord::Base
	belong_to :ubigeo
	has_many :personas
end
