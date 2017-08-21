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
      when "game_start"
        start_game(data.msg)
      when "take_turn"
        if !game.turn
          if data.move_type == "move"
            game.move_piece(data.q, data.r, data.to_q, data.to_r)
          else
            game.opponent_place(data.q, data.r, data.code);
          draw_all_ctx();
      
  send_turn: (move_type, code, q, r, to_q, to_r) ->
    data = {};
    data.move_type = move_type;
    data.code = code;
    data.q = q;
    data.r = r;
    data.to_r = to_r
    data.to_q = to_q
    @perform 'take_turn', data

      
