class AddUserToClient < ActiveRecord::Migration[5.0]
  def change
    add_reference :clients, :user
  end
end
