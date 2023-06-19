class UpdateExistingUsers < ActiveRecord::Migration[7.0]
  def up
    Usuario.where(blocked: nil).update_all(blocked: false)
  end

  def down
    # You can implement the rollback if necessary
  end
end
