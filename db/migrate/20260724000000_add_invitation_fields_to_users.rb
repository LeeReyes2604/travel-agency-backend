class AddInvitationFieldsToUsers < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :activated_at, :datetime

    # Existing accounts were created before invitations existed and must retain
    # their ability to sign in.
    execute "UPDATE users SET activated_at = CURRENT_TIMESTAMP WHERE activated_at IS NULL"
  end

  def down
    remove_column :users, :activated_at
    remove_column :users, :last_name
    remove_column :users, :first_name
  end
end
