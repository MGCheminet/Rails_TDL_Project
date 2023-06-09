class CreateSesions < ActiveRecord::Migration[7.0]
  def change
    create_table :sesions do |t|

      t.timestamps
    end
  end
end
