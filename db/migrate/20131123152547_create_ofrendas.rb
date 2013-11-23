class CreateOfrendas < ActiveRecord::Migration
  def change
    create_table :ofrendas do |t|

      t.timestamps
    end
  end
end
