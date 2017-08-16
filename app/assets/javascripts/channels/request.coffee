//= require cable
//= require_self
//= require_tree .

this.App = {}
App.cable = ActionCable.createConsumer();

App.request = App.cable.subscriptions.create "RequestChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log("made is to recived data");
    $("#friend-popup").text(data["message"]);
    $(".msg").addClass(data["class"]);
    $(".msg").css("position", "fixed");
    $(".msg").css("top", "0");
    $(".msg").css("right", "0");
    if data.link_to
        $("#game_accept").attr("href", "/accept/" + data.id);
        $("#game_accept").text("accept invite");
                        
