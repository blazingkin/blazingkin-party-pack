class WordScrambleGameService < GameService

    def render_game_client(game_session, renderer)
        renderer.render partial: 'games/client/word_scramble/word_scramble'
    end

    def render_game_host(game_session, renderer)
        renderer.render partial: 'games/host/word_scramble/word_scramble', locals: {players: game_session.players}
    end

    WORD_MIN = 4
    WORD_MAX = 12
    def receive_client_data(game_session, data, player)
        if data['word']
            word = data['word'].upcase
            return if word.length < WORD_MIN || word.length > WORD_MAX
            if is_in_word_list?(game_session, word)
                if is_word_by_player?(game_session, word, player)
                    # No points for you
                else
                    points_for_player(game_session, player, 2)
                    orig_player = remove_word_from_list(game_session, word)
                    points_for_player(game_session, orig_player, 1)
                end
            else
                add_to_word_list(game_session, word, player)
            end
            refresh_host_word_list(game_session)
        end
    end

    def recieve_host_data(game_session, data)

    end

    def init_game(game_session)
        game_session.game_datum['words'] = {}
        game_session.game_datum['players'] = {}
    end

    private

    def refresh_host_word_list(game_session)
        word_list = game_session.game_datum['words'] || {}
        scrambled = word_list.map { |k, v| v[:scrambled] }
        game_session.broadcast_host({
            event_type: 'word_update',
            render: ApplicationController.renderer.render(partial: 'games/host/word_scramble/words', locals: {words: scrambled})
        })
    end

    def is_word_by_player?(game_session, word, player)
        game_session.game_datum['words'][word][:player] == player.uuid
    end

    def add_to_word_list(game_session, word, player)
        scrambled = word.split(" ").map { |w| w.split("").shuffle.join }.join(" ")
        game_session.game_datum['words'] ||= {}
        game_session.game_datum['words'][word] = {scrambled: scrambled, player: player.uuid}
    end

    def remove_word_from_list(game_session, word)
        player = game_session.game_datum['words'][word][:player]
        game_session.game_datum['words']&.delete(word)
        Player.find_by({uuid: player})
    end

    def is_in_word_list?(game_session, word)
        word_list = game_session.game_datum['words']
        word_list&.each do |k, v|
            return true if k == word
        end
        false
    end

    def points_for_player(game_session, player, num_points)
        game_session.game_datum['players'] ||= {}
        game_session.game_datum['players'][player.uuid] ||= {}
        game_session.game_datum['players'][player.uuid]['points'] ||= 0
        game_session.game_datum['players'][player.uuid]['points'] += num_points
        game_session.broadcast_host({
            event_type: 'player_points',
            player_uuid: player.uuid,
            name: player.name,
            points: game_session.game_datum['players'][player.uuid]['points']
        })
    end

end