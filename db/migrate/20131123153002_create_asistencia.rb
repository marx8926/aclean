class CreateAsistencia < ActiveRecord::Migration
  def change
    create_table( :asistencia , :id=>false ) do |t|
      t.primary_key :int_asistencia_id
      t.string :var_asistencia_asistio, limit: 1
      t.timestamps :dat_asistencia_fecRegistro
      t.timestamps :dat_asistencia_fecAsistencia

      t.references :persona, index: true
      t.references :servicio, index: true
      t.timestamps
    end
  end
end
