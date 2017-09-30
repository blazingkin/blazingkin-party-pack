//= require cable

this.App = {};

App.cable = ActionCable.createConsumer();

function create_client_lobby_connection(game_id){
App.lobby_info = App.cable.subscriptions.create({channel: "LobbyInfoChannel", game_id: game_id}, {
    connected: function() {
      // Called when the subscription is ready for use on the server
    },
  
    disconnected: function() {
      // Called when the subscription has been terminated by the server
    },
  
    received: function(data) {
        console.log(data);
        if (data['event_type'] === 'player_leave'){
            remove_player_from_lobby_list(data['player']);
        }else if (data['event_type'] === 'player_join'){
            add_player_to_lobby_list(data['render']);
        }else if (data['event_type'] === 'player_rename'){
            rename_player_in_lobby_list(data['player_id'], data['new_name']);
        }
    }
  });
}

function remove_player_from_lobby_list(player_id){
    $(".player-"+player_id).remove();
}

function add_player_to_lobby_list(rendered_listing){
    $('.player-listing-container').append(rendered_listing);
}

function rename_player_in_lobby_list(player_id, new_name){
    $('#player-name-'+player_id).html(new_name);
}