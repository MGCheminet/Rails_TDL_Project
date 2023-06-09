class CreateDivisions < ActiveRecord::Migration[7.0]
  def change
    create_table :divisions do |t|
      t.float :monto
      t.string :paga
      t.string :recibe

      t.timestamps
    end
  end
end
