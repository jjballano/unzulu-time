class TaskPeriod < ApplicationRecord
  belongs_to :task

  before_create :start_me

  def started?
    finished_at.nil?
  end

  def duration
    return 0 if finished_at.nil?
    finished_at - started_at
  end

  def close
    self.finished_at = Time.now
    self.save
  end

  private 

  def start_me
    self.started_at = Time.now if self.started_at.nil?
  end
end
