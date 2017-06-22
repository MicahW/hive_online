class StaticPagesController < ApplicationController

  
  def home
    @hash = Hash.new("")
    @hash[:home] = "active"
    puts get_color
  end

  def contact
    @hash = Hash.new("")
    @hash[:contact] = "active"
  end
end
