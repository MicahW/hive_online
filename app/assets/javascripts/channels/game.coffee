//= require cable
//= require_self
//= require_tree .

this.App = {}
App.cable = ActionCable.createConsumer();
App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    switch data.action
      when "player_won"		
        game.set_winner(data.winner);
        draw_all_ctx();
      when "game_start"
        start_game(data.msg)
      when "take_turn"
        if game.turn == data.color
          game.flop_turn()
          if data.move_type == "move"
            console.log("game.coffe sending make move")
            console.log(data.color)
            console.log(game.color)
            game.move_piece(data.q, data.r, data.to_q, data.to_r)
            draw_all_ctx();
          else
            console.log("game.coffe sending place move")
            console.log(data.color)
            console.log(game.color)
            game.place_piece(data.q, data.r, data.code, data.color);
            draw_all_ctx();
	  
	  
		
          
          
   #move types [move, place, get_moves]   
  send_turn: (move_type, code, q, r, to_q, to_r) ->
    data = {};
    data.move_type = move_type;
    data.code = code;
    data.q = q;
    data.r = r;
    data.to_r = to_r
    data.to_q = to_q
    @perform 'take_turn', data

      
