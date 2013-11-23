class CreateUbigeos < ActiveRecord::Migration
  def change
    create_table :ubigeos do |t|

      t.timestamps
    end
  end
end
