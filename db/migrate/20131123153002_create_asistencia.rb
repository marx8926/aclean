class CreateAsistencia < ActiveRecord::Migration
  def change
    create_table( :asistencia , :id=>false ) do |t|
      t.primary_key :int_asistencia_id
      t.datetime :dat_asistencia_fecRegistro
      t.datetime :dat_asistencia_fecAsistencia
      t.integer :int_asistencia_categoria
      t.references :servicio, index: true
      t.timestamps
    end
  end
end
