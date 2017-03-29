class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client, required: false
  has_many :tasks, dependent: :destroy

  def time_day
    today = Time.now.beginning_of_day
    duration = tasks.find_all{|task| task.start_date >= today }
                    .inject(0){|sum, task| sum += task.duration }
    Time.at(duration).utc.strftime("%H:%M")    
  end

  def time_week
    5.2
  end

  def time_month
    5.2
  end

  def time_total
    5.2
  end

end
