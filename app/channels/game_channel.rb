class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{current_user.id}"
  end

  def unsubscribed
    GameValidator.forfeit(current_user.id)
  end
  
  def take_turn(data)
    data["action"] = "take_turn"
    GameValidator.make_move(current_user.id, data)
  end
end
