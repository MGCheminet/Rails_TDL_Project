class AddBlockedToUsuarios < ActiveRecord::Migration[7.0]
  def change
    add_column :usuarios, :blocked, :boolean, default: false
  end
end


