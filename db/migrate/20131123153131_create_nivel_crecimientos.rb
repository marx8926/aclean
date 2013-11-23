class CreateNivelCrecimientos < ActiveRecord::Migration
  def change
    create_table( :nivel_crecimientos, :id=>false ) do |t|

      t.primary_key :int_nivelcrecimiento_id
      t.integer :int_nivelcrecimiento_escala
      t.integer :int_nivelcrecimiento_estadoActual
      
      t.timestamps
    end
  end
end
