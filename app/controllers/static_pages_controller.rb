class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:contact]

  
  def home
    @active = Hash.new("")
    @active[:home] = "active"
  end

  def contact
    @active = Hash.new("")
    @active[:contact] = "active"
  end
  
  
end
