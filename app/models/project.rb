class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client, required: false
  has_many :tasks, dependent: :destroy

  def time_day
    today = Time.now.beginning_of_day   
    total_time(today) 
  end

  def time_week
    current_week_beginning = Time.now.beginning_of_week(:monday)
    current_week_end = Time.now.end_of_week(:monday)
    total_time(current_week_beginning, current_week_end)
  end

  def time_month
    current_month_beginning = Time.now.beginning_of_month
    current_month_end = Time.now.end_of_month
    total_time(current_month_beginning, current_month_end)
  end

  def time_total
    total_time
  end

  private 

  def total_time(from=nil, to=Time.now)
    tasks_to_sum = tasks
    tasks_to_sum = tasks_to_sum.find_all{|task| (from..to).include?(task.start_date) } unless from.nil?
    tasks_to_sum.inject(Duration.new(0)){|duration, task| duration += task.duration }
  end

end
