class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client, required: false
  has_many :tasks, dependent: :destroy

  def time_day
    5.2
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
