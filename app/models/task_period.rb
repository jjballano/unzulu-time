class TaskPeriod < ApplicationRecord
  belongs_to :task

  def started?
    finished_at.nil?
  end
end
