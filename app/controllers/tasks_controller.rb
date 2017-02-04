class TasksController < ApplicationController

  before_action :load_user
  rescue_from ActiveRecord::RecordNotFound, with: :create_user
    
  def index
  end

  def list
  end

  private 

  def load_user
    @user = User.find_by_username!(params[:user])
  end

  def create_user
    User.create(username: params[:user])
  end

end
