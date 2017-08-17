class Game < ApplicationRecord
  def self.start(player1, player2)
    white, black = [player1, player2].shuffle
    
    ActionCable.server.broadcast "player_#{white}", {action: "game_start", msg: "white"}
    ActionCable.server.broadcast "player_#{black}", {action: "game_start", msg: "black"}
  end
end
