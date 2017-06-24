class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: [:contact]

  
  def home
    @hash = Hash.new("")
    @hash[:home] = "active"
  end

  def contact
    @hash = Hash.new("")
    @hash[:contact] = "active"
  end
  
  
end
