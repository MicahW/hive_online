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
  
end
