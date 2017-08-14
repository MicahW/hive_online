module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    
    def connect
      user = User.find_by(id: cookies.signed[:user_id])
      if user != nil
        self.current_user = user
      else
       reject_unauthorized_connection
      end
    end
  end
end
