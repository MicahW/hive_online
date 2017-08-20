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
      when "move_turn"
        game.move_piece(data.q, data.r, data.to_q, data.to_r)
      when "place_turn"
        game.opponent_place(data.q, data.r, code)

      
