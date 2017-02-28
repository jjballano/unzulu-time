class TaskPeriod < ApplicationRecord
  belongs_to :task

  def started?
    finished_at.nil?
  end

  def close
    self.finished_at = Time.now
    self.save
  end
end
