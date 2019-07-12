class AddUserToLogin < ActiveRecord::Migration[5.2]
  def change
    add_reference :logins, :user, polymorphic: true
  end
end
