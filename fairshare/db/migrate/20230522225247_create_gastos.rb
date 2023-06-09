class CreateGastos < ActiveRecord::Migration[7.0]
  def change
    create_table :gastos do |t|
      t.float :monto
      t.string :descripcion
      t.date :fecha

      t.timestamps
    end
  end
end
