//= require cable
//= require_self
//= require_tree .



App.request = App.cable.subscriptions.create "RequestChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $("#friend-popup").text(data["message"]);
    $(".msg").addClass(data["class"]);
    $(".msg").css("position", "fixed");
    $(".msg").css("top", "0");
    $(".msg").css("right", "0");
    if data.link_to
        $("#game_accept").attr("href", "/accept/" + parseInt(data.link_from));
        $("#game_accept").text("accept invite");
                        
