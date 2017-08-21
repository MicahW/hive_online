class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{current_user.id}"
  end

  def unsubscribed
    Game.forfeit(current_user.id)
  end
  
  def take_turn(data)
    data["action"] = "take_turn"
    Game.make_move(current_user.id, data)
  end
end
