class CreateConstantes < ActiveRecord::Migration
  def change
    create_table :constantes do |t|

      t.timestamps
    end
  end
end
