class Game < ApplicationRecord 
  has_many :user
  
  #returns a board object from game data
  def get_board()
    list = state.split(":")
    list.each do |piece_list|
      piece_list = piece_list.split(",")
      piece_list[2] = piece_list[2] == 1 ? "white" : "black"
    end
    board = GameBoard.new(turn)
    board.fill_board(list)
  end
   
  #take a game board object and turn in to state string, then save
  def store_board(board)
    game_board = board.board
    new_state = ""
    game_board.each do |cords, stack|
      stack.each do |piece|
        new_state += cords[0] + "," + cords[1] + "," 
        new_state += piece.color == "white" ? "1" : "0" + "," + piece.type + ":"
      end
    end
    update_attributes(:state => new_state, :turn => game_board.turn_number)
  end
    
  
end