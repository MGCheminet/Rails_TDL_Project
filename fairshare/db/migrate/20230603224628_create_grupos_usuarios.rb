class CreateGruposUsuarios < ActiveRecord::Migration[7.0]
  def change
    create_table :grupos_usuarios do |t|
      t.references :grupo, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
