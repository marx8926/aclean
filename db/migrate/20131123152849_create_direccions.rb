class CreateDireccions < ActiveRecord::Migration
  def change
    create_table :direccions do |t|

      t.timestamps
    end
  end
end
