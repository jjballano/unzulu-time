class Task < ApplicationRecord
  belongs_to :project
  has_many :task_periods, dependent: :destroy

  after_create :create_period

  def started?
    task_periods.any? { |p| p.started? }
  end

  def start_date
    task_periods.order(:started_at).first.started_at unless task_periods.empty?
  end

  def finish_date  
    task_periods.order(:finished_at).last.finished_at unless started? || task_periods.empty?
  end

  def duration
    Duration.new(task_periods.inject(0){ |time, period| time += period.duration })
  end

  private

  def create_period 
    task_periods.create(nil) if task_periods.empty?
  end
end
