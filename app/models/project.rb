require 'tasks/duration'

class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client, required: false
  has_many :tasks, dependent: :destroy

  def time_day
    today = Time.now.beginning_of_day    
    tasks.find_all{|task| task.start_date >= today }
                    .inject(Duration.new(0)){|duration, task| duration += task.duration }
  end

  def time_week
    Duration.new(0)
  end

  def time_month
    Duration.new(0)
  end

  def time_total
    Duration.new(0)
  end

end
