class Piece
    attr_accessor :color, :type
    @color 
    #code{ 0:bee, 1:ant, 2:grasshopper, 3:spider, 4:beatle}
    @type
    
    def initialize(color, type)
        @color = color
        @type = type
    end
end

class GameBoard
    def initialize()
        #board is a hash, key = piece position [q,r]
        #value is a list of pieces, index = level
        @board = Hash.new
        @turn = "white"
        
        @turn_number = 0
    
        #how many left that are held
        @left = Hash.new
        @left["white"] = [1,3,3,2,2]
        @left["black"] = [1,3,3,2,2]
    end
    
    
    #place a piece true, if valid, false if otherwise
    def place_piece(q,r,color,type)
        
        #if out of those pieces, or a piece in that spot
        return false if @left[color][type] == 0 or @board[[q,r]]
        nieghbors = list_nieghbors(q,r)
        
        #must be touching a nieghbor, unless this is the first piece
        return false if nieghbors.empty? and @turn_number > 0
        
        #if touching any nigbors that are not of that color, except second move 
        nieghbors.each do |cord|
            return false if @board[cord].last.color != color and 
                                @turn_number != 1
        end
        
        #if the queen has not been placed, already plaed 3 pieces, and not 
        #placing queen now
        if @left[color][0] == 1 and @left[color].inject(:+) == 8 and
            type != 0
            return false
        end
        
        @left[color][type] -= 1
        @turn_number += 1
        place_on_top(q,r,Piece.new(color,type))
        true
        
    end
    
    def get_moves(q,r)
        piece = @board.get_to_piece(q,r)
        return nil if !piece
        moves = []
        case piece.type
            when 0
              moves = get_all_bee_moves(q,r)
            when 1
              moves = get_all_ant_moves(q,r)
            when 2
              moves = get_all_grasshopper_moves(q,r)
            when 3
              moves = get_all_spider_moves(q,r)
            when 4
               moves = get_all_beatle_moves(q,r)
        end
        return mvoes
    end
    
    #code{ 0:bee, 1:ant, 2:grasshopper, 3:spider, 4:beatle}
    def move_piece(q,r,to_q,to_r,color)
        piece = get_top_piece(q,r)
        
        
        if piece == nil or piece.color != color or 
            (!dose_not_break_hive(q,r) and @board[[q,r]].size == 1)
            return false
        end
        
        
        
        # now get a list of all the places that peice can move
        moves = []
        case piece.type
            when 0
              moves = get_all_bee_moves(q,r)
            when 1
              moves = get_all_ant_moves(q,r)
            when 2
              moves = get_all_grasshopper_moves(q,r)
            when 3
              moves = get_all_spider_moves(q,r)
            when 4
               moves = get_all_beatle_moves(q,r)
        end
        
        
        return false if !moves.include?([to_q,to_r])

        
        #now good to go, there is a piece there, it is thats pieces turn
        #the requested move is a place that piece can go
        
        place_on_top(to_q,to_r,remove_top_piece(q,r))
        return true
    end
        
        

    
    #get all niebogor offsets
    def get_offsets(q,r)
        offsets = [[q,r-1],[q+1,r-1],
        [q+1,r],[q,r+1],
        [q-1,r+1],[q-1,r]]
    end
        
    def get_top_piece(q,r)
        return nil if !@board[[q,r]]
        return @board[[q,r]].last
    end
     
    
    def remove_top_piece(q,r)
        piece = @board[[q,r]].pop
        @board[[q,r]] = nil if @board[[q,r]].empty?
        return piece
    end
        
        
    def place_on_top(q,r,piece)
        if @board[[q,r]]
            @board[[q,r]].push(piece)
        else
            @board[[q,r]] = [piece]
        end
    end
    
    #get a list of moves a piece can make that complies with
    #freedom of movment
    def list_fom_moves(q,r)
        offsets = get_offsets(q,r)
        fom_list = []
        (0..5).each do |i|
            if !@board[offsets[i]] &&
                (!@board[offsets[(i+1) % 6]] ||
                 !@board[offsets[(i-1) % 6]])
                 fom_list.push(offsets[i])
            end
        end
        fom_list
    end
    
    #get a list of nieghbors
    def list_nieghbors(q,r)
        offsets = get_offsets(q,r)
        n_list = []
        (0..5).each do |i|
            if @board[offsets[i]]
                 n_list.push(offsets[i])
            end
        end
        n_list
    end
    
    #get a list of neighbors exluding a spot
    def list_nieghbors_minus(cords,minus_q,minus_r)
        list_nieghbors(cords[0],cords[1]) - [minus_q,minus_r]
    end
    
    
    #if this piece was removed would it
    #breack the hive into two
    def dose_not_break_hive(q,r)
        #serch from start to all surounding
        final_list = list_nieghbors(q,r)
        if final_list.size == 0
            raise "shoudl not be moving a piece not connected"
        elsif final_list.size == 1
            return true
        else
            que = [final_list.pop()]
            visit_list = [[q,r]]
            #ensure a path from start to all finals
            while !que.empty?
                new_que = []
                visit_list = (visit_list + que).uniq
                final_list = final_list - que
                return true if final_list.empty?
                que.each do |node|
                    neighbors = list_nieghbors(node[0],node[1])
                    new_que = (new_que + (neighbors - visit_list)).uniq
                end
                que = new_que
            end
            return false
        end
    end
    
    # a list of nieghbor empty spaces that are connected 
    # to at least one piece
    def connected_list(q,r)
        offsets = get_offsets(q,r)
        n_list = []
        offsets.each do |i|
            if !@board[i] &&
                !list_nieghbors_minus(i,q,r).empty?
                 n_list.push(i)
            end
        end
        n_list
    end
    
    #a list a places can move once that is connected to a piece
    #and complies with freedom of movement
    def list_moves_step(cords)
        q = cords[0]
        r = cords[1]
        connected_list(q,r) & list_fom_moves(q,r)
    end
        
        
    
    
    #branch out a get a list of places a piece can move
    def get_all_ant_moves(q,r)
        saved_pieces = @board[[q,r]]
        @board[[q,r]] = nil
        que = [[q,r]]
        visit_list = []
        while !que.empty?
            new_que = []
            visit_list = (visit_list + que).uniq
            que.each do |node|
                moves = list_moves_step(node)
                new_que = (new_que + (moves - visit_list)).uniq
            end
            que = new_que
        end
        @board[[q,r]] = saved_pieces
        return visit_list - [[q,r]]
    end
    
    #get all moves a spider can make
    def get_all_spider_moves(q,r)
        saved_pieces = @board[[q,r]]
        @board[[q,r]] = nil
        list = spider_helper([q,r],[[q,r]],0,list_nieghbors(q,r))
        @board[[q,r]] = saved_pieces
        return list.uniq
    end
    
    def spider_helper(cord,visited,level,next_to)
        final = []
        if level < 3
            connected = list_moves_step(cord)
            connected.each do |step|
                # if not in visited list, and not moving to a piece
                #it was not touching
                step_nieghbors = list_nieghbors(step[0],step[1])
                if !visited.include?(step) and 
                    (next_to - step_nieghbors).size < next_to.size
                  final += spider_helper(
                      step,visited.clone.push(step), level+1,step_nieghbors
                      )
                end
            end
            return final
        else
            return [cord]
        end
    end
    
    #gets all grasshopper moves
    def get_all_grasshopper_moves(q,r)
        movments = list_nieghbors(q,r)
        list = []
        movments.each do |move|
            next_q = move[0]
            next_r = move[1]
            list.push push_forward(next_q,next_r,next_q-q,next_r-r)
        end
        return list
    end
    
    #keeps steping foward in a direction untill there is
    #a empty space
    def push_forward(q,r,q_add,r_add)
        if @board[[q, r]]
          return push_forward(q+q_add,r+r_add,q_add,r_add)
        else 
          return [q,r]
        end
    end
    
    def get_all_bee_moves(q,r)
        pieces = @board[[q,r]]
        @board[[q,r]] = nil
        next_to = list_nieghbors(q,r)
        pot_moves = list_moves_step([q,r])
        moves = []
        pot_moves.each do |move|
            new_connections = list_nieghbors(move[0],move[1])
            if ((next_to - new_connections).size < next_to.size)
              moves.push(move)
            end
        end
        
        @board[[q,r]] = pieces
        return moves
    end

    def get_all_beatle_moves(q,r)
      list = []
      #if the beatle is a bottom piece it is resricted to fom + pieces it can go on top of
      if @board[[q,r]].size == 1
        list = get_all_bee_moves(q,r) + list_nieghbors(q,r)
      else 
         list = get_offsets(q,r)
      end
      list
    end
        

    #used for testing
    def fill_board(list)
        #format [q,r,color,type]
        list.each do |el|
            piece = Piece.new(el[2],el[3])
            place_on_top(el[0],el[1],piece)
        end
        
    end
    
    def print_list(list)
        list.each do |i|
            print "#{i[0]} , #{i[1]} | "
        end
        puts ""
    end
end

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
