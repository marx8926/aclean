class CreateLugars < ActiveRecord::Migration
  def change
    create_table :lugars do |t|

      t.timestamps
    end
  end
end
