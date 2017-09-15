class GameValidator
  
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
    user = User.find(uuid1)
    game = Game.find(user.game_id)
    game.update_attribute(:white_id, white)
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
    game = Game.find(User.find(uuid).game_id)
    correct_turn = (game.turn % 2) == 0 ? "white" : "black"
    turn = (uuid == game.white_id) ? "white" : "black"
    
    if correct_turn == turn
      game_board = board.get_board()
      valid_turn = true
      
      if data["move_type"] == "move"
        valid_turn = game_board.move_piece(
          data["q"],data["r"],data["to_q"],data["to_r"],correct_turn)
      else if data["move_type"] == "place"
        valid_turn = game_baord.place_piece(
          data["q"],data["r"],correct_turn,data["code"])
      end
      
      if valid_turn
        data["color"] = correct_turn
        game.update_attribute(:turn, game.turn + 1)
        game.store_board(game_board)
        
        ActionCable.server.broadcast "player_#{uuid}", data
        ActionCable.server.broadcast "player_#{opponent}", data
      end
    end
  end
  
  
  
end