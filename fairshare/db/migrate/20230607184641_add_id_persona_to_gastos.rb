class AddIdPersonaToGastos < ActiveRecord::Migration[7.0]
  def change
    add_column :gastos, :id_usuario, :bigint
  end
end
