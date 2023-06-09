class AddGrupoIdToGastos < ActiveRecord::Migration[7.0]
  def change
    add_reference :gastos, :grupo, null: false, foreign_key: true
  end
end
