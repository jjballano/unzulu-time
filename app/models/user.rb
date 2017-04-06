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
    projects.inject(Duration.new(0)){|sum, project| sum += project.time_day }
  end

  def total_week
    projects.inject(Duration.new(0)){|sum, project| sum += project.time_week }        
  end

  def total_month
    projects.inject(Duration.new(0)){|sum, project| sum += project.time_month }    
  end

end
