class User < ApplicationRecord
  validates :username, presence: true, uniqueness: { case_sensitive: false }   
  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects
  after_initialize :set_defaults

  def set_defaults
    registered = false if registered.nil?
  end

end
