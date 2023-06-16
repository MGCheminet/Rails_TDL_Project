class AddDeletedAtToUsuarios < ActiveRecord::Migration[7.0]
  def change
    add_column :usuarios, :deleted_at, :datetime
    add_index :usuarios, :deleted_at
  end
end
