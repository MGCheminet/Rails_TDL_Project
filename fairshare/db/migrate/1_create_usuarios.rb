class CreateUsuarios < ActiveRecord::Migration[7.0]
  def change
    create_table :usuarios do |t|
      t.string :nombre
      t.string :email
      t.string :password_digest

      t.timestamps
    end

    add_column :usuarios, :admin, :boolean, default: false
    add_column :usuarios, :deleted_at, :datetime
    add_index :usuarios, :deleted_at
    add_column :usuarios, :blocked, :boolean, default: false
  end
end
