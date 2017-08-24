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
    attr_acccessor :board, :turn_number
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
        print q
        print " "
        puts r
        
        #if out of those pieces, or a piece in that spot
        return false if @left[color][type] == 0 or @board[[q,r]]
        
        puts("passed first")
        
        nieghbors = list_nieghbors(q,r)
        
        #must be touching a nieghbor, unless this is the first piece
        return false if nieghbors.empty? and @turn_number > 0
        
        puts("passed second")
        
        #if touching any nigbors that are not of that color, except second move 
        nieghbors.each do |cord|
            puts "#{cord[0]} , #{cord[1]}"
            return false if @board[cord].last.color != color and 
                                @turn_number != 1
        end
        
        puts("passed third")
        
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
    
    #move a pice true if valid, false if otherwise
    def move_piece(from_q, from_r, to_q, to_r)
    end
    
    def get_offsets(q,r)
        offsets = [[q,r-1],[q+1,r-1],
        [q+1,r],[q,r+1],
        [q-1,r+1],[q-1,r]]
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
    
    #a list a places can move once
    def list_moves_step(cords)
        q = cords[0]
        r = cords[1]
        connected_list(q,r) & list_fom_moves(q,r)
    end
        
        
    
    
    #branch out a get a list of places a piece can move
    #starting at q,r limit is for spider, they only move 3 spaces
    def get_all_moves(q,r,limit)
        saved_pieces = @board[[q,r]]
        @board[[q,r]] = nil
        que = [[q,r]]
        visit_list = []
        step = limit ? 0 : 4 #only count 3 spaces 
        while !que.empty? && step != 3
            step += 1
            new_que = []
            visit_list = (visit_list + que).uniq
            que.each do |node|
                moves = list_moves_step(node)
                new_que = (new_que + (moves - visit_list)).uniq
            end
            que = new_que
        end
        @board[[q,r]] = saved_pieces
        if (limit)
            return que - [[q,r]]
        else 
            return visit_list - [[q,r]]
        end
        
    end
  
  def fill_board(list)
        #format [q,r,color,type]
        list.each do |el|
            piece = Piece.new(el[2],el[3])
            place_on_top(el[0],el[1],piece)
            @left[el[2]] -= 1
        end
        
    end
end