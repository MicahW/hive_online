class Game < ApplicationRecord
  
  def self.set_opponents(uid1, uid2)
    user1 = User.find(uid1)
    user2 = User.find(uid2)
    user1.update_attribute(:opponent_id, uid2)
    user2.update_attribute(:opponent_id, uid1)
  end
  
  def self.get_opponent(uid)
    user = User.find(uid)
    user.opponent_id
  end
  
  def self.start(uuid1, uuid2)
    white, black = [uuid1, uuid2].shuffle

    ActionCable.server.broadcast "player_#{white}", {action: "game_start", msg: "white"}
    ActionCable.server.broadcast "player_#{black}", {action: "game_start", msg: "black"}

    set_opponents(uuid1, uuid2)
  end

  def self.forfeit(uuid)
    if winner = get_opponent(uid)
      ActionCable.server.broadcast "player_#{winner}", {action: "opponent_forfeits"}
    end
  end


  def self.make_move(uuid, data)
    opponent = get_opponent(uuid)
    ActionCable.server.broadcast "player_#{opponent}", data
  end
  
  
  
end