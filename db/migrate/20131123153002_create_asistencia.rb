class CreateAsistencia < ActiveRecord::Migration
  def change
    create_table :asistencia do |t|

      t.timestamps
    end
  end
end