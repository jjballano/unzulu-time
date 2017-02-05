class Task < ApplicationRecord
  belongs_to :project
  has_many :task_periods, dependent: :destroy

  after_create :create_period

  def started?
    task_periods.any? { |p| p.started? }
  end

  private

  def create_period 
    task_periods.create(started_at: Time.now)
  end
end
