class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # rescue_from :abort, with: :user_not_valid
  # around_action :handle_throws

  private 

  def user_not_valid
    p "ENTRAAAAAA"
    @user = User.find_by_username(params[:user])
    redirect_to "/#{@user.username}"
  end

  def handle_throws
    catch :user_not_valid do
      p "LLEGAAAA"
    end
  end
end
