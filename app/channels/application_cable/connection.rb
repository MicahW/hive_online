module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_ by: current_user
    
    def connect
      if logged_in?
        selfcurrent_user = current_user
      else
       reject_unauthorized_connection
      end
  end
end
