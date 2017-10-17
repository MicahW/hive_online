class Game < ApplicationRecord 
  has_many :user
  
  #returns a board object from game data
  def get_board()
    #puts "loading board, state: #{state}"
    list = state.split(":")
    load_list = []
    list.each do |piece_list|
      piece_list = piece_list.split(",")
      
      piece_list[2] = "black" if piece_list[2] == "0"
      piece_list[2] = "white" if piece_list[2] == "1"
      
      piece_list[0] = piece_list[0].to_i
      piece_list[1] = piece_list[1].to_i
      piece_list[3] = piece_list[3].to_i
      
      load_list.push(piece_list)
    end
    board = GameBoard.new
    board.set_turn(turn)
    #puts load_list
    board.fill_board(load_list)
    return board
  end
   
  #take a game board object and turn in to state string, then save
  def store_board(board)
    game_board = board.get_board
    new_state = ""
    game_board.each do |cords, stack|
      if stack != nil
        stack.each do |piece|
          new_state += cords[0].to_s + "," + cords[1].to_s + "," 
        
          new_state += "1" if piece.color == "white"
          new_state += "0" if piece.color == "black"
        
          new_state += "," + piece.type.to_s + ":"
        end
      end
    end
    #puts "storing board, state: #{new_state}"
    #puts ""
    update_attributes(:state => new_state, :turn => board.get_turn)
  end
    
  
end