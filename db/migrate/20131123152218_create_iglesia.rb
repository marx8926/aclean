class CreateIglesia < ActiveRecord::Migration
  def change
    create_table :iglesia do |t|

      t.timestamps
    end
  end
end
