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
      when "game_start" then start_game(data.msg)
      else null
      
