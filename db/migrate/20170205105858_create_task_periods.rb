class CreateTaskPeriods < ActiveRecord::Migration[5.0]
  def change
    create_table :task_periods do |t|
      t.datetime :started_at
      t.datetime :finished_at
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
