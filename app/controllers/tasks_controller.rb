class TasksController < ApplicationController

  before_action :load_user
  before_action :set_project, only: [:create]
    
  def index
    @task = Task.new
    if @user.tasks.empty?
      @task.project = Project.new
    else
      @task.project = @user.tasks.order("updated_at DESC").first.project unless @user.tasks.empty?
    end
  end

  def list
  end

  def create
    @task = @project.tasks.create(nil)
    @task_period = @task.task_periods.first
    respond_to do |format|
      format.js
    end
  end

  private 

  def load_user
    @user = User.find_by_username(params[:user])
    create_user if @user.nil?
  end

  def create_user
    @user = User.create(username: params[:user])
  end

  def set_project
    @project = Project.where(user: @user, name: params[:project]).first
    create_project if @project.nil?
  end

  def create_project
    @project = Project.create(user: @user, name: params[:project])
  end

end
