class CreateNivelCrecimientos < ActiveRecord::Migration
  def change
    create_table :nivel_crecimientos do |t|

      t.timestamps
    end
  end
end
