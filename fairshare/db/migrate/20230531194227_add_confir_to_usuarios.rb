class AddConfirToUsuarios < ActiveRecord::Migration[7.0]
    def change
      add_column :usuarios, :confir, :string
    end  
end
