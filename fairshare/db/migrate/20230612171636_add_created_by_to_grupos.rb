class AddCreatedByToGrupos < ActiveRecord::Migration[7.0]
  def change
    add_column :grupos, :created_by, :integer
  end
end
