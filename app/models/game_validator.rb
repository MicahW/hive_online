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

  def self.forfeit(uid)
     winner = get_opponent(uid)
     ActionCable.server.broadcast "player_#{winner}", {action: "player_won", winner: "you"}
     game = Game.find(User.find(uid).game_id)
     Game.destroy(game.id)
  end


  def self.make_move(uuid, data)
    opponent = get_opponent(uuid)
    game = Game.find(User.find(uuid).game_id)
    return false if !game
    correct_turn = (game.turn % 2) == 0 ? "white" : "black"
    turn = (uuid == game.white_id) ? "white" : "black"
    puts ">> in make move"
    if correct_turn == turn
      puts ">> correct turn"
      game_board = game.get_board()
      puts ">> get game board complete"
      valid_turn = true
      
      if data["move_type"] == "move"
        valid_turn = game_board.move_piece(
          data["q"],data["r"],data["to_q"],data["to_r"],correct_turn)
      elsif data["move_type"] == "place"
        valid_turn = game_board.place_piece(
          data["q"],data["r"],correct_turn,data["code"])
      end
      
      puts ">> valid turn = #{valid_turn}"
      
      if valid_turn
        data["color"] = correct_turn
        game.update_attribute(:turn, game.turn + 1)
        game.store_board(game_board) 
        ActionCable.server.broadcast "player_#{uuid}", data
        ActionCable.server.broadcast "player_#{opponent}", data
        if game_board.is_winner != "none"
          ActionCable.server.broadcast "player_#{uuid}", {action: "player_won", winner: game_board.is_winner}
          ActionCable.server.broadcast "player_#{opponent}", {action: "player_won", winner: game_board.is_winner}
          Game.destroy(game.id)
        end
      end
    end
  end
end

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  