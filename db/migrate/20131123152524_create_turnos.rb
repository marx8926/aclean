class CreateTurnos < ActiveRecord::Migration
  def change
    create_table( :turnos , :id=>false )do |t|
      t.primary_key :int_turno_id
      t.string :var_turno_horaInicio, limit: 10
      t.string :var_turno_horaFin, limit: 10
      t.integer :int_turno_dia
      
      t.timestamps
    end
  end
end
