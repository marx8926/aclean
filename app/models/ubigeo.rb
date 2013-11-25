class Ubigeo < ActiveRecord::Base
	has_many :iglesias
	has_many :direccions
end
