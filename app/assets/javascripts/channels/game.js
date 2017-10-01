function create_game_client_connection(template){
  App.game = App.cable.subscriptions.create("GameChannel", {
    connected: function(){
      $('.container-fluid').html(template);
    },

    disconnected: function(){

    },

    received: function(data){
      console.log(data);
      if (data['event_type'] === 'change_view'){
        $('.container-fluid').html(data['render']);
      }
      App.gamejs.receive(data);
    }
  });
}