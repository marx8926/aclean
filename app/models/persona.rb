class Persona < ActiveRecord::Base
	belongs_to :iglesia
	has_many :telefonos
	belongs_to :persona
	belongs_to :lugar
	has_many :nivel_crecimientos
	has_many :diezmos
	has_many :asistencias
	has_many :direccions
	has_many :peticions

	def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |persona|
        csv << persona.attributes.values_at(*column_names)
      end
    end
  end
end
