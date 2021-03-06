module ApplicationHelper
  
    
  def add_friendship(user1, user2)
    unless exists_friendship?(user1, user2)
      user1.friend.create(friend_id: user2.id)
      user2.friend.create(friend_id: user1.id)
    end
  end
  
  def remove_friendship(user1, user2)
   if exists_friendship?(user1, user2)
    user1.friend.find_by(friend_id: user2.id).destroy
    user2.friend.find_by(friend_id: user1.id).destroy
   end
  end
  
  def exists_friendship?(user1, user2)
    user1.friend.exists?(friend_id: user2.id)
  end
  
  def send_message(to, message, type)
    channel = "request:#{to.id}"
    data = {:message => message, :class => "bg-" + type, :link_to => false}
    ActionCable.server.broadcast(channel, data)
  end 
  
  def send_invite(to, message, type, from)
    channel = "request:#{to.id}"
    data = {:message => message, 
            :class => "bg-" + type, 
            :link_to => true,
            :link_from => from.id}
    ActionCable.server.broadcast(channel, data)
  end
  
end
