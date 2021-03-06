class ApplicationController < ActionController::Base
  include SessionsHelper
  include ApplicationHelper

  
  def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
        store_location
      end
  end
  
  def correct_user
    @user = User.find(params[:id])
    current_user?(@user)
  end

end
