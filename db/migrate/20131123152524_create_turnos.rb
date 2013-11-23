class CreateTurnos < ActiveRecord::Migration
  def change
    create_table :turnos do |t|

      t.timestamps
    end
  end
end
