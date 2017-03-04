class AddBillableToTask < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :billable, :boolean, default: true
    Task.all.each do |task|
      task.billable = true
    end 
  end
end
