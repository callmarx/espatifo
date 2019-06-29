class AddUserToOperational < ActiveRecord::Migration[5.2]
  def change
    add_reference :operationals, :user, foreign_key: true
  end
end
