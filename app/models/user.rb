class User < ApplicationRecord
  validates :username, presence: true, uniqueness: { case_sensitive: false }   
  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects
  has_many :clients, dependent: :destroy
  
  after_initialize :set_defaults

  def set_defaults
    registered = false if registered.nil?
  end

  def total_day
    8.52
  end

  def total_week
    22.55
  end

  def total_month
    143.2
  end

end
