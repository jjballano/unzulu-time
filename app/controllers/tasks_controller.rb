class TasksController < ApplicationController

  before_action :load_user
  before_action :set_projects, only: [:index]
    
  def index
  end

  def list
  end

  def start    
  end

  private 

  def load_user
    @user = User.find_by_username(params[:user])
    create_user if @user.nil?
  end

  def create_user
    @user = User.create(username: params[:user])
  end

  def set_projects
    @projects = @user.projects.map(&:name)
  end

end
