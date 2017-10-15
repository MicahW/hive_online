#these are game modle loading and sotring tests


test "test load and store" do
    game = Game.create(:state => "", :turn => 0)
    board = game.get_board
    assert(board.place_piece(2,1,"white",3),"failed to place")
    board.inc_turn
    board.store_board
    puts "here"
    
    #assert(!board.place_piece(0,1,"black",4),"failed to not place")
    #assert(board.place_piece(2,2,"black",3),"failed to place")
    
    #assert(!board.place_piece(1,2,"white",4),"failed to not place")
    #assert(board.place_piece(1,1,"white",3),"failed to place")
    
    #assert(!board.place_piece(0,1,"black",4),"failed to not place")
    #assert(board.place_piece(2,3,"black",3),"failed to place")
    
    #assert(!board.place_piece(2,0,"white",3),"failed to not place")
    #assert(board.place_piece(2,0,"white",2),"failed to place")
    
    #assert(!board.place_piece(3,0,"white",2),"failed to not place")
    #assert(board.place_piece(3,0,"white",0),"failed to place")
end
    

#these are game logic tests

#some tests dont need color and tpye do just add that
def add_fillers(list)
    list.each do |el|
        el.push("white").push(0)
    end
end

def assert(exp, msg)
    unless (exp)
        raise msg
    else
        puts "assertion true: #{msg}"
    end
end

def same?(list1, list2)
  assert(
         ((list1 & list2).size == list1.size) &&
         list1.size == list2.size, "incorect")
end

def test_fom()
    board = GameBoard.new
    list = add_fillers([[1,1],[1,2],[2,1],[3,0],
                        [3,-1],[2,-1],[4,-2]])
    board.fill_board(list)
    same?(board.list_fom_moves(2,1), [[2,2],[3,1]])
    same?(board.list_fom_moves(3,-1), [])
    same?(board.list_fom_moves(1,1), [[2,0],[1,0],[0,1],[0,2]])
end

def test_hive_break()
    board = GameBoard.new
    list = add_fillers([[1,1],[1,2],[2,1],[3,0],
                        [3,-1],[2,-1],[4,-2],[1,0],[4,0]])
    board.fill_board(list)
    assert(board.dose_not_break_hive(4,-2),"failed, expted true at 4,-2")
    assert(board.dose_not_break_hive(1,0),"failed, expted true at 1,0")
    assert(board.dose_not_break_hive(1,1),"failed, expted true at 1,1")
    assert(!board.dose_not_break_hive(3,0),"failed, expted false at 3,0")
    assert(!board.dose_not_break_hive(3,-1),"failed, expted false at 4,-2")
end

def test_connected_list
    board = GameBoard.new
    list = add_fillers([[1,1],[1,2],[2,1],[3,0],
                        [3,-1],[2,-1],[4,-2],[1,0],[4,0]])
    board.fill_board(list)
    same?(board.connected_list(0,2), [[0,1],[0,3]])
    same?(board.connected_list(2,1), [[2,0],[2,2],[3,1]])
end

def test_get_all_ant_moves
    board = GameBoard.new
    list = add_fillers([[1,0],[2,1],[2,2],[3,0],[3,-1],[4,-1]])
    correct1 = [[1,-1],[2,-1],[3,-2],[4,-2],[5,-2],[5,-1],[4,0],[3,1],[1,2],
                [1,1],[0,1],[0,0]]
    board.fill_board(list)
    same?(board.get_all_ant_moves(2,2), correct1)
end

def test_get_all_spider_moves
    board = GameBoard.new
    list = add_fillers([[0,2],[1,1],[1,3]])
    board.fill_board(list)
    same?(board.get_all_spider_moves(0,2), [[2,0],[2,3],[0,4]])
end

def test_place_piece 
    board = GameBoard.new
    assert(board.place_piece(2,1,"white",3),"failed to place")
    
    assert(!board.place_piece(0,1,"black",4),"failed to not place")
    assert(board.place_piece(2,2,"black",3),"failed to place")
    
    assert(!board.place_piece(1,2,"white",4),"failed to not place")
    assert(board.place_piece(1,1,"white",3),"failed to place")
    
    assert(!board.place_piece(0,1,"black",4),"failed to not place")
    assert(board.place_piece(2,3,"black",3),"failed to place")
    
    assert(!board.place_piece(2,0,"white",3),"failed to not place")
    assert(board.place_piece(2,0,"white",2),"failed to place")
    
    assert(!board.place_piece(3,0,"white",2),"failed to not place")
    assert(board.place_piece(3,0,"white",0),"failed to place")
    
end

def test_get_all_grasshopper_moves
    board = GameBoard.new
    list = add_fillers([[1,1],[0,2],[1,2],[1,3],[1,4]])
    board.fill_board(list)
    same?(board.get_all_grasshopper_moves(0,2), [[2,0],[2,2]])
    same?(board.get_all_grasshopper_moves(1,1), [[-1,3],[1,5]])
    same?(board.get_all_grasshopper_moves(1,2), [[1,0],[-1,2],[1,5]])
end

def test_get_all_bee_moves
    board = GameBoard.new
    list = add_fillers([[1,2],[0,3],[0,4],[1,4],[1,6]])
    board.fill_board(list)
    same?(board.get_all_bee_moves(0,3), [[0,2],[-1,4]])
    same?(board.get_all_bee_moves(1,2), [[0,2],[1,3]])
    same?(board.get_all_bee_moves(1,4), [[1,3],[0,5]])
end

def test_get_all_beatle_moves
    board = GameBoard.new
    list = add_fillers([[1,2],[0,3],[0,4],[1,4],[1,6]])
    board.fill_board(list)
    same?(board.get_all_beatle_moves(0,3), [[0,2],[-1,4],[1,2],[0,4]])
    same?(board.get_all_beatle_moves(1,2), [[0,2],[1,3],[0,3]])
    same?(board.get_all_beatle_moves(1,4), [[1,3],[0,5],[0,4]])
end
# assert(board.move_piece(),"make move")
# assert(!board.move_piece(),"not make move")
def test_make_moves
    board = GameBoard.new
    list = [[6,2,2,0],[5,3,0,1],[5,4,1,1],[3,5,3,0],[4,5,4,0],[3,6,1,1],
            [4,6,3,0],[5,6,1,0],[2,7,4,1],[3,7,1,0],[3,8,0,0],[2,9,2,1]]
    list.each do |i|
        i[3] = (i[3] == 0) ? "white" : "black"
    end
    list.each do |i|
        x = i[3]
        i[3] = i[2]
        i[2] = x
    end
    board.fill_board(list)
    assert(!board.move_piece(5,4,3,4,"black"),"not moving")
    assert(!board.move_piece(6,2,4,4,"black"),"not make move")
    assert(board.move_piece(6,2,4,4,"white"),"make move")
    assert(board.move_piece(4,4,6,2,"white"),"make move")
    assert(!board.move_piece(3,7,4,7,"white"),"not make move")
    assert(board.move_piece(3,5,1,8,"white"),"make move")
    assert(!board.move_piece(5,6,2,8,"white"),"not make move")
    assert(board.move_piece(5,6,1,9,"white"),"make move")
    assert(board.move_piece(3,8,4,7,"white"),"make move")
    assert(board.move_piece(6,2,4,4,"white"),"make move")
    assert(board.move_piece(5,4,3,8,"black"),"make move")
    assert(board.place_piece(5,5,"white",4),"add beatle")
    assert(board.move_piece(5,5,4,5,"white"),"make move")
    assert(board.move_piece(4,5,4,6,"white"), "beatl move on top")
    assert(board.move_piece(4,6,3,7,"white"),"make move")
    assert(board.move_piece(4,6,4,8,"white"),"make move")
    assert(board.move_piece(2,7,3,7,"black"),"make move")
    assert(board.move_piece(3,7,4,7,"black"),"make move")
    assert(board.move_piece(4,7,4,6,"black"),"make move")
    assert(board.move_piece(3,7,2,8,"white"),"make move")
    
end

test_fom
test_hive_break
test_connected_list
test_get_all_ant_moves
test_get_all_spider_moves
test_place_piece
test_get_all_grasshopper_moves
test_get_all_bee_moves
test_get_all_beatle_moves
test_make_moves