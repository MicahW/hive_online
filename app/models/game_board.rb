class GameBoard
    
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

    def initialize()
        #board is a hash, key = piece position [q,r]
        #value is a list of pieces, index = level
        @board = Hash.new
        
        @turn_number = 0
    
        #how many left that are held
        @left = Hash.new
        @left["white"] = [1,3,3,2,2]
        @left["black"] = [1,3,3,2,2]
    end
  
    
    def set_turn(turn)
      @turn_number = turn
    end
    
    def get_turn()
        return @turn_number 
    end
  
    def get_board()
      return @board
    end
  
    def print_board
      print "game object turn: #{@turn_number} state: "
      @board.each do |cord, pieces|
        pieces.each do |piece|
          print("#{cord[0]},#{cord[1]},#{piece.color},#{piece.type}:")
        end
      end
      puts ""
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
        @turn_number += 1
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
            @left[piece.color][piece.type] -= 1
        end
        
    end
    
    def print_list(list)
        list.each do |i|
            print "#{i[0]} , #{i[1]} | "
        end
        puts ""
    end
end


