class CreateDiezmos < ActiveRecord::Migration
  def change
    create_table( :diezmos, :id=>false ) do |t|
      t.integer :int_diezmo_id
      t.decimal :dec_diezmo_monto, precision: 18, scale: 2
      t.timestamps :dat_diezmo_fechaRegistro
      t.string :var_diezmo_peticion, limit: 200
      t.timestamps
    end
  end
end
