class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name

      t.timestamps
    end
    add_reference(:projects, :client)
  end
end
