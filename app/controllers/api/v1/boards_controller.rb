module Api
  module V1
    class BoardsController < ApiController
      def update
        game = Game.find(params[:game_id])
        player = User.find_by(api_key: params[:api_key])
        if playing_game?(game, params[:api_key])
          result = ShipPlacerService.new(player.find_board(game), params[:ship_size], params[:start_space], params[:end_space])
          render json: { "message": "#{result.message}"}
        else
        end
      end

      private

      def playing_game?(game, player_api_key)
        game.player_1_api_key == player_api_key || game.player_2_api_key == player_api_key
      end
    end
  end
end
