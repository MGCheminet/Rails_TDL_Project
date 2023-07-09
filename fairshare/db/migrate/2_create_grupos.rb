class CreateGrupos < ActiveRecord::Migration[7.0]
  def change
    create_table :grupos do |t|
      t.string :nombre
      t.string :descripcion

      t.timestamps
    end
    add_column :grupos, :created_by, :integer
  end
end
