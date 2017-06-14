class StaticPagesController < ApplicationController
  
  
  
  def home
    @hash = Hash.new("")
    @hash[:home] = "active"
  end

  def contact
    @hash = Hash.new("")
    @hash[:contact] = "active"
  end
end
