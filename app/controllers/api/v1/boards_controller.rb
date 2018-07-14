module Api
  module V1
    class BoardsController < ApiController
      # def update
      #   game = Game.find(params[:game_id])
      #   player = User.find_by(api_key: request.headers["HTTP_X_API_KEY"])
      #   require 'pry'; binding.pry
      #   if playing_game?(game, request.headers["HTTP_X_API_KEY"])
      #     result = ShipPlacerService.new(player.find_board(game), params[:ship_size], params[:start_space], params[:end_space])
      #     session[:message] = result.message
      #     redirect_to api_v1_game_path(game)
      #   else
      #     render json: { "message": "You must be a part of this game in order to place your ships."}
      #     redirect_to dashboard_path(player)
      #   end
      # end

      private

      # def playing_game?(game, player_api_key)
      #   game.player_1_api_key == player_api_key || game.player_2_api_key == player_api_key
      # end
    end
  end
end
